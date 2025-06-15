import 'package:flutter/foundation.dart';
import '../core/services/document_service.dart';
import '../models/document_model.dart';
import 'document_id_generator.dart';

/// Service to test document ID resolution and verify the fixes work correctly
class DocumentResolutionTestService {
  static DocumentResolutionTestService? _instance;
  static DocumentResolutionTestService get instance =>
      _instance ??= DocumentResolutionTestService._();

  DocumentResolutionTestService._();

  final DocumentService _documentService = DocumentService.instance;

  /// Test document ID resolution with the problematic "daftar_isi" case
  Future<Map<String, dynamic>> testDocumentResolution() async {
    try {
      debugPrint('🧪 Starting document resolution test...');
      
      final testResults = <String, dynamic>{
        'timestamp': DateTime.now().toIso8601String(),
        'tests': <Map<String, dynamic>>[],
        'summary': <String, dynamic>{},
      };

      // Test case 1: Direct lookup of "daftar_isi"
      await _testDirectLookup('daftar_isi', testResults);
      
      // Test case 2: Test with filename "1748961795557_daftar_isi.pdf"
      await _testFilenameGeneration('1748961795557_daftar_isi.pdf', testResults);
      
      // Test case 3: Test alternative ID generation strategies
      await _testAlternativeStrategies('daftar_isi', testResults);
      
      // Test case 4: Test with various document ID formats
      final testIds = [
        'daftar_isi',
        'doc_daftar_isi',
        'sync_123456_daftarisi',
        '1748961795557_daftar_isi',
        'daftar_isi.pdf',
      ];
      
      for (final testId in testIds) {
        await _testDocumentLookup(testId, testResults);
      }
      
      // Generate summary
      _generateTestSummary(testResults);
      
      debugPrint('✅ Document resolution test completed');
      return testResults;
    } catch (e) {
      debugPrint('❌ Document resolution test failed: $e');
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Test direct document lookup
  Future<void> _testDirectLookup(String documentId, Map<String, dynamic> results) async {
    try {
      debugPrint('🔍 Testing direct lookup for: $documentId');
      
      final startTime = DateTime.now();
      final document = await _documentService.getDocumentById(documentId);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      final testResult = {
        'test': 'direct_lookup',
        'input': documentId,
        'found': document != null,
        'documentId': document?.id,
        'fileName': document?.fileName,
        'duration_ms': duration,
        'success': true,
      };
      
      if (document != null) {
        debugPrint('✅ Direct lookup successful: ${document.fileName}');
      } else {
        debugPrint('⚠️ Direct lookup failed for: $documentId');
      }
      
      (results['tests'] as List).add(testResult);
    } catch (e) {
      debugPrint('❌ Direct lookup error for $documentId: $e');
      (results['tests'] as List).add({
        'test': 'direct_lookup',
        'input': documentId,
        'found': false,
        'error': e.toString(),
        'success': false,
      });
    }
  }

  /// Test document ID generation from filename
  Future<void> _testFilenameGeneration(String fileName, Map<String, dynamic> results) async {
    try {
      debugPrint('🔧 Testing ID generation for filename: $fileName');
      
      final generatedId = DocumentIdGenerator.generateFromFileName(fileName);
      final possibleIds = DocumentIdGenerator.generatePossibleIds(fileName);
      
      debugPrint('   Generated ID: $generatedId');
      debugPrint('   Possible IDs: ${possibleIds.join(', ')}');
      
      // Test if any of the generated IDs can find a document
      DocumentModel? foundDocument;
      String? foundWithId;
      
      for (final possibleId in possibleIds) {
        try {
          final doc = await _documentService.getDocumentById(possibleId);
          if (doc != null) {
            foundDocument = doc;
            foundWithId = possibleId;
            break;
          }
        } catch (e) {
          // Continue with next ID
        }
      }
      
      final testResult = {
        'test': 'filename_generation',
        'input': fileName,
        'generated_id': generatedId,
        'possible_ids': possibleIds,
        'found_document': foundDocument != null,
        'found_with_id': foundWithId,
        'document_filename': foundDocument?.fileName,
        'success': true,
      };
      
      if (foundDocument != null) {
        debugPrint('✅ Found document with ID: $foundWithId');
      } else {
        debugPrint('⚠️ No document found with any generated ID');
      }
      
      (results['tests'] as List).add(testResult);
    } catch (e) {
      debugPrint('❌ Filename generation test error: $e');
      (results['tests'] as List).add({
        'test': 'filename_generation',
        'input': fileName,
        'error': e.toString(),
        'success': false,
      });
    }
  }

  /// Test alternative ID resolution strategies
  Future<void> _testAlternativeStrategies(String searchTerm, Map<String, dynamic> results) async {
    try {
      debugPrint('🔍 Testing alternative strategies for: $searchTerm');
      
      // Test filename search
      final documents = await _documentService.getAllDocuments(limit: 100);
      final matchingDocs = documents.where(
        (doc) => doc.fileName.toLowerCase().contains(searchTerm.toLowerCase()),
      ).toList();
      
      debugPrint('   Found ${matchingDocs.length} documents with filename containing "$searchTerm"');
      
      final testResult = {
        'test': 'alternative_strategies',
        'input': searchTerm,
        'total_documents': documents.length,
        'matching_documents': matchingDocs.length,
        'matching_files': matchingDocs.map((doc) => {
          'id': doc.id,
          'fileName': doc.fileName,
          'category': doc.category,
        }).toList(),
        'success': true,
      };
      
      (results['tests'] as List).add(testResult);
    } catch (e) {
      debugPrint('❌ Alternative strategies test error: $e');
      (results['tests'] as List).add({
        'test': 'alternative_strategies',
        'input': searchTerm,
        'error': e.toString(),
        'success': false,
      });
    }
  }

  /// Test document lookup with various ID formats
  Future<void> _testDocumentLookup(String testId, Map<String, dynamic> results) async {
    try {
      debugPrint('🔍 Testing lookup for ID: $testId');
      
      final startTime = DateTime.now();
      final document = await _documentService.getDocumentById(testId);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      final isStandardFormat = DocumentIdGenerator.isStandardFormat(testId);
      
      final testResult = {
        'test': 'document_lookup',
        'input': testId,
        'found': document != null,
        'is_standard_format': isStandardFormat,
        'duration_ms': duration,
        'success': true,
      };
      
      if (document != null) {
        testResult['document'] = {
          'id': document.id,
          'fileName': document.fileName,
          'category': document.category,
          'filePath': document.filePath,
        };
        debugPrint('✅ Found document: ${document.fileName}');
      } else {
        debugPrint('⚠️ No document found for ID: $testId');
      }
      
      (results['tests'] as List).add(testResult);
    } catch (e) {
      debugPrint('❌ Document lookup error for $testId: $e');
      (results['tests'] as List).add({
        'test': 'document_lookup',
        'input': testId,
        'found': false,
        'error': e.toString(),
        'success': false,
      });
    }
  }

  /// Generate test summary
  void _generateTestSummary(Map<String, dynamic> results) {
    final tests = results['tests'] as List;
    
    final summary = {
      'total_tests': tests.length,
      'successful_tests': tests.where((t) => t['success'] == true).length,
      'failed_tests': tests.where((t) => t['success'] == false).length,
      'documents_found': tests.where((t) => t['found'] == true).length,
      'documents_not_found': tests.where((t) => t['found'] == false).length,
      'average_lookup_time_ms': _calculateAverageLookupTime(tests),
    };
    
    results['summary'] = summary;
    
    debugPrint('📊 Test Summary:');
    debugPrint('   Total tests: ${summary['total_tests']}');
    debugPrint('   Successful: ${summary['successful_tests']}');
    debugPrint('   Failed: ${summary['failed_tests']}');
    debugPrint('   Documents found: ${summary['documents_found']}');
    debugPrint('   Documents not found: ${summary['documents_not_found']}');
    debugPrint('   Average lookup time: ${summary['average_lookup_time_ms']}ms');
  }

  /// Calculate average lookup time
  double _calculateAverageLookupTime(List tests) {
    final durationsMs = tests
        .where((t) => t['duration_ms'] != null)
        .map((t) => t['duration_ms'] as int)
        .toList();
    
    if (durationsMs.isEmpty) return 0.0;
    
    final total = durationsMs.reduce((a, b) => a + b);
    return total / durationsMs.length;
  }

  /// Quick test for the specific "daftar_isi" issue
  Future<bool> quickTestDaftarIsi() async {
    try {
      debugPrint('🚀 Quick test for daftar_isi issue...');
      
      // Try to find the document using enhanced resolution
      final document = await _documentService.getDocumentById('daftar_isi');
      
      if (document != null) {
        debugPrint('✅ SUCCESS: Found document with enhanced resolution');
        debugPrint('   Document ID: ${document.id}');
        debugPrint('   File Name: ${document.fileName}');
        debugPrint('   Category: ${document.category}');
        return true;
      } else {
        debugPrint('⚠️ Document still not found with enhanced resolution');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Quick test failed: $e');
      return false;
    }
  }
}
