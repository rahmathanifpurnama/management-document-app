import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Centralized document ID generation service to ensure consistency
/// across all Firebase Storage and Firestore operations
class DocumentIdGenerator {
  static const String _idPrefix = 'doc';
  static const String _syncPrefix = 'sync';

  /// Generate a consistent document ID from filename
  /// This is the primary method that should be used across all services
  static String generateFromFileName(String fileName) {
    try {
      debugPrint('🔑 Generating document ID from filename: $fileName');

      // Remove file extension
      final nameWithoutExt = fileName.split('.').first;

      // Remove timestamp prefix if exists (format: 1234567890_filename)
      String cleanName = nameWithoutExt;
      if (RegExp(r'^\d+_').hasMatch(nameWithoutExt)) {
        cleanName = nameWithoutExt.split('_').skip(1).join('_');
      }

      // Clean the name: keep only alphanumeric characters and underscores
      cleanName = cleanName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

      // Ensure it's not empty
      if (cleanName.isEmpty) {
        cleanName = 'unnamed_file';
      }

      // IMPROVED: Smart truncation for long filenames
      // Instead of hard cut at 50 chars, use intelligent truncation
      String documentId;
      if (cleanName.length > 80) {
        // For very long names, use hash-based approach with meaningful prefix
        final shortName = cleanName.length > 20
            ? cleanName.substring(0, 20)
            : cleanName;
        final hash = _generateShortHash(cleanName);
        documentId = '${_idPrefix}_${shortName}_$hash';
      } else if (cleanName.length > 60) {
        // For moderately long names, truncate intelligently
        documentId = '${_idPrefix}_${_intelligentTruncate(cleanName, 55)}';
      } else {
        // For normal length names, use as-is
        documentId = '${_idPrefix}_$cleanName';
      }

      debugPrint('✅ Generated document ID: $documentId');

      return documentId;
    } catch (e) {
      debugPrint('❌ Error generating document ID from filename: $e');
      // Fallback to hash-based ID
      return generateFromHash(fileName);
    }
  }

  /// Generate a short hash for long filenames
  static String _generateShortHash(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString().substring(0, 8);
  }

  /// Intelligently truncate filename preserving meaningful parts
  static String _intelligentTruncate(String name, int maxLength) {
    if (name.length <= maxLength) return name;

    // Try to preserve the beginning and end of the filename
    final halfLength = (maxLength - 3) ~/ 2; // Account for "..."
    final start = name.substring(0, halfLength);
    final end = name.substring(name.length - halfLength);

    return '${start}___$end'; // Use triple underscore as separator
  }

  /// Generate document ID using file path hash for uniqueness
  /// Used as fallback or for files with problematic names
  static String generateFromHash(String input) {
    try {
      debugPrint('🔑 Generating hash-based document ID from: $input');

      // Create MD5 hash of the input
      final bytes = utf8.encode(input);
      final digest = md5.convert(bytes);
      final hashString = digest.toString();

      // Take first 12 characters of hash for reasonable length
      final shortHash = hashString.substring(0, 12);

      final documentId = '${_idPrefix}_hash_$shortHash';
      debugPrint('✅ Generated hash-based document ID: $documentId');

      return documentId;
    } catch (e) {
      debugPrint('❌ Error generating hash-based document ID: $e');
      // Ultimate fallback
      return '${_idPrefix}_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Generate unique document ID for sync operations
  /// Combines file path hash with clean filename for better traceability
  static String generateForSync(String filePath, String fileName) {
    try {
      debugPrint('🔑 Generating sync document ID for: $fileName at $filePath');

      // Generate base ID from filename
      final baseId = generateFromFileName(fileName);

      // Create a short hash from file path for uniqueness
      final pathBytes = utf8.encode(filePath);
      final pathDigest = md5.convert(pathBytes);
      final pathHash = pathDigest.toString().substring(0, 8);

      final documentId =
          '${_syncPrefix}_${pathHash}_${baseId.replaceFirst('${_idPrefix}_', '')}';
      debugPrint('✅ Generated sync document ID: $documentId');

      return documentId;
    } catch (e) {
      debugPrint('❌ Error generating sync document ID: $e');
      return generateFromHash('$filePath$fileName');
    }
  }

  /// Try to resolve document ID using multiple strategies
  /// This helps find documents that might have been created with different ID generation methods
  static List<String> generatePossibleIds(String fileName, {String? filePath}) {
    final possibleIds = <String>[];

    try {
      // Strategy 1: Current standardized method
      possibleIds.add(generateFromFileName(fileName));

      // Strategy 2: Legacy method (just filename without extension)
      final nameWithoutExt = fileName.split('.').first;
      String legacyName = nameWithoutExt;
      if (RegExp(r'^\d+_').hasMatch(nameWithoutExt)) {
        legacyName = nameWithoutExt.split('_').skip(1).join('_');
      }
      if (legacyName.isNotEmpty && !possibleIds.contains(legacyName)) {
        possibleIds.add(legacyName);
      }

      // Strategy 3: Hash-based method
      possibleIds.add(generateFromHash(fileName));

      // Strategy 4: Sync method if file path is provided
      if (filePath != null) {
        possibleIds.add(generateForSync(filePath, fileName));
      }

      // Strategy 5: Clean filename variations
      final cleanVariations = [
        fileName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
        fileName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_'),
        fileName.split('.').first.toLowerCase(),
      ];

      for (final variation in cleanVariations) {
        if (variation.isNotEmpty && !possibleIds.contains(variation)) {
          possibleIds.add(variation);
        }
      }

      debugPrint(
        '🔍 Generated ${possibleIds.length} possible document IDs for $fileName',
      );
      debugPrint('   Possible IDs: ${possibleIds.join(', ')}');
    } catch (e) {
      debugPrint('❌ Error generating possible document IDs: $e');
    }

    return possibleIds;
  }

  /// Validate if a document ID follows the current standard format
  static bool isStandardFormat(String documentId) {
    return documentId.startsWith(_idPrefix) ||
        documentId.startsWith(_syncPrefix);
  }

  /// Extract original filename from document ID if possible
  static String? extractFilenameFromId(String documentId) {
    try {
      if (documentId.startsWith('${_idPrefix}_')) {
        return documentId.replaceFirst('${_idPrefix}_', '');
      } else if (documentId.startsWith('${_syncPrefix}_')) {
        final parts = documentId.split('_');
        if (parts.length >= 3) {
          return parts.skip(2).join('_');
        }
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error extracting filename from document ID: $e');
      return null;
    }
  }
}
