import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../core/config/feature_flags.dart';

/// Service for comprehensive deletion operation diagnostics and error analysis
class DeletionDiagnosticsService {
  static const String _logPrefix = '🔍 DELETION_DIAGNOSTICS';

  /// Comprehensive diagnostic analysis for deletion operations
  static Future<Map<String, dynamic>> analyzeDeletionOperation({
    required List<DocumentModel> files,
    required String operationType, // 'single' or 'bulk'
    required String userId,
    required bool isAdmin,
  }) async {
    final diagnostics = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'operationType': operationType,
      'userId': userId,
      'isAdmin': isAdmin,
      'enhancedDiagnostics': true,
    };

    try {
      // Basic operation info
      diagnostics['fileCount'] = files.length;
      diagnostics['featureFlags'] = _getRelevantFeatureFlags();

      // File analysis
      final fileAnalysis = await _analyzeFiles(files);
      diagnostics['fileAnalysis'] = fileAnalysis;

      // Path analysis
      final pathAnalysis = _analyzeFilePaths(files);
      diagnostics['pathAnalysis'] = pathAnalysis;

      // Risk assessment
      final riskAssessment = _assessDeletionRisks(files, fileAnalysis, pathAnalysis);
      diagnostics['riskAssessment'] = riskAssessment;

      // Recommendations
      final recommendations = _generateRecommendations(riskAssessment, fileAnalysis);
      diagnostics['recommendations'] = recommendations;

      if (FeatureFlags.enableDeleteOperationLogging) {
        _logDiagnostics(diagnostics);
      }

    } catch (e) {
      diagnostics['diagnosticError'] = e.toString();
      debugPrint('$_logPrefix Error during diagnostic analysis: $e');
    }

    return diagnostics;
  }

  /// Analyze individual files for potential issues
  static Future<Map<String, dynamic>> _analyzeFiles(List<DocumentModel> files) async {
    final analysis = <String, dynamic>{
      'fileTypes': <String, int>{},
      'pathPatterns': <String, int>{},
      'potentialIssues': <String>[],
      'fileDetails': <Map<String, dynamic>>[],
    };

    for (final file in files) {
      // File type analysis
      final fileType = _categorizeFileType(file.fileType);
      analysis['fileTypes'][fileType] = (analysis['fileTypes'][fileType] ?? 0) + 1;

      // Path pattern analysis
      final pathPattern = _categorizePathPattern(file.filePath);
      analysis['pathPatterns'][pathPattern] = (analysis['pathPatterns'][pathPattern] ?? 0) + 1;

      // Issue detection
      final issues = _detectFileIssues(file);
      (analysis['potentialIssues'] as List<String>).addAll(issues);

      // Detailed file info (limited to first 10 for performance)
      if ((analysis['fileDetails'] as List).length < 10) {
        (analysis['fileDetails'] as List<Map<String, dynamic>>).add({
          'id': file.id,
          'fileName': file.fileName,
          'fileType': fileType,
          'pathPattern': pathPattern,
          'filePath': file.filePath,
          'fileSize': file.fileSize,
          'issues': issues,
        });
      }
    }

    return analysis;
  }

  /// Analyze file path patterns for potential issues
  static Map<String, dynamic> _analyzeFilePaths(List<DocumentModel> files) {
    final analysis = <String, dynamic>{
      'emptyPaths': 0,
      'categorizedFiles': 0,
      'uncategorizedFiles': 0,
      'userSpecificPaths': 0,
      'suspiciousPatterns': <String>[],
    };

    for (final file in files) {
      final path = file.filePath;

      if (path.isEmpty) {
        analysis['emptyPaths']++;
        continue;
      }

      final parts = path.split('/');

      // Categorized vs uncategorized
      if (parts.length >= 3 && parts[1] == 'categories') {
        analysis['categorizedFiles']++;
      } else {
        analysis['uncategorizedFiles']++;
      }

      // User-specific paths
      if (parts.length >= 3 && parts[0] == 'documents' && parts[1] != 'categories') {
        analysis['userSpecificPaths']++;
      }

      // Suspicious patterns
      if (path.contains('..') || path.contains('//') || path.startsWith('/')) {
        (analysis['suspiciousPatterns'] as List<String>).add(path);
      }
    }

    return analysis;
  }

  /// Assess risks associated with the deletion operation
  static Map<String, dynamic> _assessDeletionRisks(
    List<DocumentModel> files,
    Map<String, dynamic> fileAnalysis,
    Map<String, dynamic> pathAnalysis,
  ) {
    final risks = <String, dynamic>{
      'riskLevel': 'LOW', // LOW, MEDIUM, HIGH, CRITICAL
      'riskFactors': <String>[],
      'mitigationSuggestions': <String>[],
    };

    int riskScore = 0;

    // Empty paths increase risk
    final emptyPaths = pathAnalysis['emptyPaths'] as int;
    if (emptyPaths > 0) {
      riskScore += emptyPaths * 2;
      risks['riskFactors'].add('$emptyPaths files with empty storage paths');
      risks['mitigationSuggestions'].add('Verify file existence before deletion');
    }

    // Suspicious path patterns
    final suspiciousPatterns = pathAnalysis['suspiciousPatterns'] as List<String>;
    if (suspiciousPatterns.isNotEmpty) {
      riskScore += suspiciousPatterns.length * 3;
      risks['riskFactors'].add('${suspiciousPatterns.length} files with suspicious path patterns');
      risks['mitigationSuggestions'].add('Review path patterns before deletion');
    }

    // Large number of files
    if (files.length > 100) {
      riskScore += 2;
      risks['riskFactors'].add('Large batch deletion (${files.length} files)');
      risks['mitigationSuggestions'].add('Consider processing in smaller batches');
    }

    // PDF files (known issue)
    final fileTypes = fileAnalysis['fileTypes'] as Map<String, int>;
    final pdfCount = fileTypes['PDF'] ?? 0;
    if (pdfCount > 0) {
      riskScore += 1;
      risks['riskFactors'].add('$pdfCount PDF files (known path resolution issues)');
      risks['mitigationSuggestions'].add('Monitor PDF file deletions closely');
    }

    // Determine risk level
    if (riskScore >= 10) {
      risks['riskLevel'] = 'CRITICAL';
    } else if (riskScore >= 6) {
      risks['riskLevel'] = 'HIGH';
    } else if (riskScore >= 3) {
      risks['riskLevel'] = 'MEDIUM';
    }

    risks['riskScore'] = riskScore;
    return risks;
  }

  /// Generate recommendations based on analysis
  static List<String> _generateRecommendations(
    Map<String, dynamic> riskAssessment,
    Map<String, dynamic> fileAnalysis,
  ) {
    final recommendations = <String>[];

    final riskLevel = riskAssessment['riskLevel'] as String;
    final fileTypes = fileAnalysis['fileTypes'] as Map<String, int>;

    if (riskLevel == 'CRITICAL' || riskLevel == 'HIGH') {
      recommendations.add('Consider manual review before proceeding');
      recommendations.add('Process files in smaller batches');
    }

    if ((fileTypes['PDF'] ?? 0) > 0) {
      recommendations.add('Enable enhanced path resolution for PDF files');
      recommendations.add('Monitor deletion success rate for PDF files');
    }

    final potentialIssues = fileAnalysis['potentialIssues'] as List<String>;
    if (potentialIssues.isNotEmpty) {
      recommendations.add('Review and resolve ${potentialIssues.length} potential file issues');
    }

    if (recommendations.isEmpty) {
      recommendations.add('Operation appears safe to proceed');
    }

    return recommendations;
  }

  /// Categorize file type for analysis
  static String _categorizeFileType(String fileType) {
    final lowerFileType = fileType.toLowerCase();
    if (lowerFileType.contains('pdf')) return 'PDF';
    if (lowerFileType.contains('image') || lowerFileType.contains('jpg') || lowerFileType.contains('png')) return 'Image';
    if (lowerFileType.contains('doc')) return 'Document';
    if (lowerFileType.contains('excel') || lowerFileType.contains('sheet')) return 'Spreadsheet';
    return 'Other';
  }

  /// Categorize path pattern for analysis
  static String _categorizePathPattern(String filePath) {
    if (filePath.isEmpty) return 'empty';
    final parts = filePath.split('/');
    if (parts.length >= 3 && parts[1] == 'categories') return 'categorized';
    if (parts.length == 2 && parts[0] == 'documents') return 'direct';
    if (parts.length == 3 && parts[0] == 'documents') return 'user_specific';
    return 'other';
  }

  /// Detect potential issues with individual files
  static List<String> _detectFileIssues(DocumentModel file) {
    final issues = <String>[];

    if (file.filePath.isEmpty) {
      issues.add('Empty file path');
    }
    if (file.id.isEmpty) {
      issues.add('Empty document ID');
    }
    if (file.fileName.isEmpty) {
      issues.add('Empty file name');
    }
    if (file.fileSize <= 0) {
      issues.add('Invalid file size');
    }

    return issues;
  }

  /// Get relevant feature flags for diagnostics
  static Map<String, bool> _getRelevantFeatureFlags() {
    return {
      'useCloudFunctionDelete': FeatureFlags.useCloudFunctionDelete,
      'enableEnhancedDeleteErrorHandling': FeatureFlags.enableEnhancedDeleteErrorHandling,
      'enableDeleteOperationLogging': FeatureFlags.enableDeleteOperationLogging,
      'enforceAdminOnlyDeletion': FeatureFlags.enforceAdminOnlyDeletion,
    };
  }

  /// Log diagnostic information
  static void _logDiagnostics(Map<String, dynamic> diagnostics) {
    if (!FeatureFlags.enableDeleteOperationLogging) return;

    debugPrint('$_logPrefix Deletion Operation Analysis:');
    debugPrint('   Operation: ${diagnostics['operationType']}');
    debugPrint('   Files: ${diagnostics['fileCount']}');
    debugPrint('   Risk Level: ${diagnostics['riskAssessment']['riskLevel']}');
    
    final fileTypes = diagnostics['fileAnalysis']['fileTypes'] as Map<String, int>;
    if (fileTypes.isNotEmpty) {
      debugPrint('   File Types: ${fileTypes.entries.map((e) => '${e.key}:${e.value}').join(', ')}');
    }

    final recommendations = diagnostics['recommendations'] as List<String>;
    if (recommendations.isNotEmpty) {
      debugPrint('   Recommendations: ${recommendations.length}');
      for (int i = 0; i < recommendations.length && i < 3; i++) {
        debugPrint('     - ${recommendations[i]}');
      }
    }
  }

  /// Analyze deletion operation results
  static Map<String, dynamic> analyzeResults({
    required int totalFiles,
    required int successfulDeletions,
    required int failedDeletions,
    required Map<String, Map<String, dynamic>> errorDetails,
  }) {
    final analysis = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'totalFiles': totalFiles,
      'successfulDeletions': successfulDeletions,
      'failedDeletions': failedDeletions,
      'successRate': totalFiles > 0 ? (successfulDeletions / totalFiles * 100).toStringAsFixed(1) : '0.0',
    };

    if (errorDetails.isNotEmpty) {
      // Analyze error patterns
      final errorPatterns = <String, int>{};
      final fileTypeErrors = <String, int>{};

      for (final error in errorDetails.values) {
        final errorType = error['errorType'] as String? ?? 'Unknown';
        final fileType = error['fileTypeCategory'] as String? ?? 'Unknown';

        errorPatterns[errorType] = (errorPatterns[errorType] ?? 0) + 1;
        fileTypeErrors[fileType] = (fileTypeErrors[fileType] ?? 0) + 1;
      }

      analysis['errorPatterns'] = errorPatterns;
      analysis['fileTypeErrors'] = fileTypeErrors;

      // Identify primary issues
      if (errorPatterns.isNotEmpty) {
        final primaryError = errorPatterns.entries.reduce((a, b) => a.value > b.value ? a : b);
        analysis['primaryErrorType'] = primaryError.key;
        analysis['primaryErrorCount'] = primaryError.value;
      }

      if (fileTypeErrors.isNotEmpty) {
        final mostAffectedType = fileTypeErrors.entries.reduce((a, b) => a.value > b.value ? a : b);
        analysis['mostAffectedFileType'] = mostAffectedType.key;
        analysis['mostAffectedCount'] = mostAffectedType.value;
      }
    }

    if (FeatureFlags.enableDeleteOperationLogging) {
      debugPrint('$_logPrefix Deletion Results Analysis:');
      debugPrint('   Success Rate: ${analysis['successRate']}% (${successfulDeletions}/${totalFiles})');
      if (analysis.containsKey('primaryErrorType')) {
        debugPrint('   Primary Error: ${analysis['primaryErrorType']} (${analysis['primaryErrorCount']} occurrences)');
      }
      if (analysis.containsKey('mostAffectedFileType')) {
        debugPrint('   Most Affected Type: ${analysis['mostAffectedFileType']} (${analysis['mostAffectedCount']} failures)');
      }
    }

    return analysis;
  }
}
