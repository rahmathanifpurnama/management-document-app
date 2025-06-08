import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../../models/document_model.dart';
import '../../models/activity_model.dart';

class DocumentService {
  static DocumentService? _instance;
  static DocumentService get instance => _instance ??= DocumentService._();

  DocumentService._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  // Get all documents
  Future<List<DocumentModel>> getAllDocuments() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.documentsCollection
          .orderBy('uploadedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get documents: ${e.toString()}');
    }
  }

  // Get document by ID
  Future<DocumentModel?> getDocumentById(String documentId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.documentsCollection
          .doc(documentId)
          .get();

      if (doc.exists) {
        return DocumentModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }

  // Add document
  Future<String> addDocument(DocumentModel document) async {
    try {
      DocumentReference docRef = await _firebaseService.documentsCollection.add(
        document.toMap(),
      );

      // Log activity
      await _logActivity(
        document.uploadedBy,
        ActivityType.upload,
        'Document: ${document.fileName}',
      );

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add document: ${e.toString()}');
    }
  }

  // Update document
  Future<void> updateDocument(DocumentModel document) async {
    try {
      await _firebaseService.documentsCollection
          .doc(document.id)
          .update(document.toMap());

      // Log activity
      await _logActivity(
        document.uploadedBy,
        ActivityType.update,
        'Document: ${document.fileName}',
      );
    } catch (e) {
      throw Exception('Failed to update document: ${e.toString()}');
    }
  }

  // Delete document permanently (from both Firestore and Storage)
  Future<void> deleteDocument(String documentId, String deletedBy) async {
    try {
      // Get document data first
      DocumentModel? document = await getDocumentById(documentId);

      if (document == null) {
        throw Exception('Document not found');
      }

      // Delete from Firebase Storage if filePath exists
      if (document.filePath.isNotEmpty) {
        try {
          // Create storage reference from file path
          Reference storageRef = _firebaseService.storage.ref().child(
            document.filePath,
          );
          await storageRef.delete();
        } catch (storageError) {
          // Log storage deletion error but continue with Firestore deletion
          // Warning: Failed to delete file from storage, but continue with Firestore deletion
          // Don't throw here, continue with Firestore deletion
        }
      }

      // Delete from Firestore
      await _firebaseService.documentsCollection.doc(documentId).delete();

      // Log activity
      await _logActivity(
        deletedBy,
        ActivityType.delete,
        'Document: ${document.fileName}',
      );
    } catch (e) {
      throw Exception('Failed to delete document: ${e.toString()}');
    }
  }

  // Delete document from storage only (for cleanup)
  Future<void> deleteDocumentFromStorage(String filePath) async {
    try {
      if (filePath.isNotEmpty) {
        Reference storageRef = _firebaseService.storage.ref().child(filePath);
        await storageRef.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete file from storage: ${e.toString()}');
    }
  }

  // Get documents by category
  Future<List<DocumentModel>> getDocumentsByCategory(String categoryId) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.documentsCollection
          .where('category', isEqualTo: categoryId)
          .orderBy('uploadedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get documents by category: ${e.toString()}');
    }
  }

  // Get documents by user
  Future<List<DocumentModel>> getDocumentsByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.documentsCollection
          .where('uploadedBy', isEqualTo: userId)
          .orderBy('uploadedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get documents by user: ${e.toString()}');
    }
  }

  // Update document category
  Future<void> updateDocumentCategory(
    String documentId,
    String newCategoryId,
  ) async {
    try {
      await _firebaseService.documentsCollection.doc(documentId).update({
        'category': newCategoryId,
      });
    } catch (e) {
      throw Exception('Failed to update document category: ${e.toString()}');
    }
  }

  // Update document status
  Future<void> updateDocumentStatus(
    String documentId,
    String status,
    String updatedBy,
  ) async {
    try {
      await _firebaseService.documentsCollection.doc(documentId).update({
        'status': status,
        'approvedBy': updatedBy,
        'approvedAt': FieldValue.serverTimestamp(),
      });

      // Log activity
      await _logActivity(
        updatedBy,
        ActivityType.update,
        'Document Status: $status',
      );
    } catch (e) {
      throw Exception('Failed to update document status: ${e.toString()}');
    }
  }

  // Search documents
  Future<List<DocumentModel>> searchDocuments(String query) async {
    try {
      // Search by filename
      QuerySnapshot nameQuery = await _firebaseService.documentsCollection
          .where('fileName', isGreaterThanOrEqualTo: query)
          .where('fileName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      Set<DocumentModel> documents = {};

      // Add results from name search
      for (var doc in nameQuery.docs) {
        documents.add(DocumentModel.fromFirestore(doc));
      }

      return documents.toList();
    } catch (e) {
      throw Exception('Failed to search documents: ${e.toString()}');
    }
  }

  // Get recent documents
  Future<List<DocumentModel>> getRecentDocuments({int limit = 10}) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.documentsCollection
          .orderBy('uploadedAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent documents: ${e.toString()}');
    }
  }

  // Log activity
  Future<void> _logActivity(
    String userId,
    ActivityType action,
    String resource,
  ) async {
    try {
      ActivityModel activity = ActivityModel(
        id: '',
        userId: userId,
        action: action.value,
        resource: resource,
        timestamp: DateTime.now(),
        details: {'userAgent': 'Flutter App', 'platform': 'Mobile'},
      );

      await _firebaseService.activitiesCollection.add(activity.toMap());
    } catch (e) {
      // Don't throw error for activity logging
      // Failed to log activity, but continue execution
    }
  }
}
