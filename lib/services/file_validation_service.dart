import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import '../core/constants/file_validation_constants.dart';

enum FileValidationError {
  invalidExtension,
  invalidMimeType,
  invalidMagicNumber,
  fileTooLarge,
  filenameTooLong,
  filenameTooShort,
  dangerousExtension,
  suspiciousFilename,
  cannotReadFile,
  emptyFile,
}

class FileValidationResult {
  final bool isValid;
  final List<FileValidationError> errors;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  const FileValidationResult({
    required this.isValid,
    this.errors = const [],
    this.errorMessage,
    this.metadata,
  });

  factory FileValidationResult.valid({Map<String, dynamic>? metadata}) {
    return FileValidationResult(
      isValid: true,
      metadata: metadata,
    );
  }

  factory FileValidationResult.invalid({
    required List<FileValidationError> errors,
    String? errorMessage,
  }) {
    return FileValidationResult(
      isValid: false,
      errors: errors,
      errorMessage: errorMessage,
    );
  }
}

class FileValidationService {
  static const FileValidationService _instance = FileValidationService._internal();
  factory FileValidationService() => _instance;
  const FileValidationService._internal();

  /// Comprehensive file validation
  Future<FileValidationResult> validateFile(XFile file) async {
    final errors = <FileValidationError>[];
    final metadata = <String, dynamic>{};

    try {
      // 1. Validate filename
      final filenameValidation = _validateFilename(file.name);
      if (!filenameValidation.isValid) {
        errors.addAll(filenameValidation.errors);
      }

      // 2. Validate extension
      final extension = _getFileExtension(file.name);
      if (!_isExtensionAllowed(extension)) {
        errors.add(FileValidationError.invalidExtension);
      }

      // 3. Check for dangerous extensions
      if (_isDangerousExtension(extension)) {
        errors.add(FileValidationError.dangerousExtension);
      }

      // 4. Check for suspicious filename patterns
      if (_hasSuspiciousPattern(file.name)) {
        errors.add(FileValidationError.suspiciousFilename);
      }

      // 5. Read file bytes for further validation
      Uint8List? fileBytes;
      try {
        fileBytes = await file.readAsBytes();
        metadata['fileSize'] = fileBytes.length;
      } catch (e) {
        errors.add(FileValidationError.cannotReadFile);
        return FileValidationResult.invalid(
          errors: errors,
          errorMessage: 'Cannot read file: ${e.toString()}',
        );
      }

      // 6. Check if file is empty
      if (fileBytes.isEmpty) {
        errors.add(FileValidationError.emptyFile);
      }

      // 7. Validate file size
      final sizeValidation = _validateFileSize(fileBytes.length, extension);
      if (!sizeValidation.isValid) {
        errors.addAll(sizeValidation.errors);
      }

      // 8. Validate magic number (file signature)
      if (fileBytes.isNotEmpty) {
        final magicValidation = _validateMagicNumber(fileBytes, extension);
        if (!magicValidation.isValid) {
          errors.addAll(magicValidation.errors);
        }
      }

      // 9. Additional metadata
      metadata['extension'] = extension;
      metadata['mimeType'] = _getMimeType(extension);
      metadata['isImage'] = _isImageFile(extension);
      metadata['isDocument'] = _isDocumentFile(extension);

      if (errors.isEmpty) {
        return FileValidationResult.valid(metadata: metadata);
      } else {
        return FileValidationResult.invalid(
          errors: errors,
          errorMessage: _generateErrorMessage(errors),
        );
      }
    } catch (e) {
      return FileValidationResult.invalid(
        errors: [FileValidationError.cannotReadFile],
        errorMessage: 'Validation failed: ${e.toString()}',
      );
    }
  }

  /// Validate multiple files
  Future<Map<String, FileValidationResult>> validateFiles(List<XFile> files) async {
    final results = <String, FileValidationResult>{};
    
    for (final file in files) {
      results[file.name] = await validateFile(file);
    }
    
    return results;
  }

  /// Quick validation for file picker (before reading bytes)
  FileValidationResult quickValidateFile(String filename) {
    final errors = <FileValidationError>[];

    // Validate filename
    final filenameValidation = _validateFilename(filename);
    if (!filenameValidation.isValid) {
      errors.addAll(filenameValidation.errors);
    }

    // Validate extension
    final extension = _getFileExtension(filename);
    if (!_isExtensionAllowed(extension)) {
      errors.add(FileValidationError.invalidExtension);
    }

    // Check for dangerous extensions
    if (_isDangerousExtension(extension)) {
      errors.add(FileValidationError.dangerousExtension);
    }

    // Check for suspicious patterns
    if (_hasSuspiciousPattern(filename)) {
      errors.add(FileValidationError.suspiciousFilename);
    }

    if (errors.isEmpty) {
      return FileValidationResult.valid();
    } else {
      return FileValidationResult.invalid(
        errors: errors,
        errorMessage: _generateErrorMessage(errors),
      );
    }
  }

  // Private validation methods
  FileValidationResult _validateFilename(String filename) {
    final errors = <FileValidationError>[];

    if (filename.length > FileValidationConstants.maxFilenameLength) {
      errors.add(FileValidationError.filenameTooLong);
    }

    if (filename.length < FileValidationConstants.minFilenameLength) {
      errors.add(FileValidationError.filenameTooShort);
    }

    return errors.isEmpty
        ? FileValidationResult.valid()
        : FileValidationResult.invalid(errors: errors);
  }

  FileValidationResult _validateFileSize(int fileSize, String extension) {
    final sizeInfo = FileValidationConstants.getMaxFileSizeForExtension(extension);
    final maxSize = sizeInfo['size'] as int;

    if (fileSize > maxSize) {
      return FileValidationResult.invalid(
        errors: [FileValidationError.fileTooLarge],
      );
    }

    return FileValidationResult.valid();
  }

  FileValidationResult _validateMagicNumber(Uint8List bytes, String extension) {
    final magicNumbers = FileValidationConstants.fileMagicNumbers[extension.toLowerCase()];
    
    if (magicNumbers == null) {
      // No magic number validation for this file type
      return FileValidationResult.valid();
    }

    for (final magicNumber in magicNumbers) {
      if (bytes.length >= magicNumber.length) {
        bool matches = true;
        for (int i = 0; i < magicNumber.length; i++) {
          if (bytes[i] != magicNumber[i]) {
            matches = false;
            break;
          }
        }
        if (matches) {
          return FileValidationResult.valid();
        }
      }
    }

    return FileValidationResult.invalid(
      errors: [FileValidationError.invalidMagicNumber],
    );
  }

  // Helper methods
  String _getFileExtension(String filename) {
    final parts = filename.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool _isExtensionAllowed(String extension) {
    return FileValidationConstants.allowedExtensions.contains(extension.toLowerCase());
  }

  bool _isDangerousExtension(String extension) {
    return FileValidationConstants.dangerousExtensions.contains(extension.toLowerCase());
  }

  bool _hasSuspiciousPattern(String filename) {
    final lowerFilename = filename.toLowerCase();
    for (final pattern in FileValidationConstants.suspiciousPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(lowerFilename)) {
        return true;
      }
    }
    return false;
  }

  String? _getMimeType(String extension) {
    final mimeTypes = FileValidationConstants.allowedMimeTypes[extension.toLowerCase()];
    return mimeTypes?.first;
  }

  bool _isImageFile(String extension) {
    return ['jpg', 'jpeg', 'png'].contains(extension.toLowerCase());
  }

  bool _isDocumentFile(String extension) {
    return ['pdf', 'doc', 'docx', 'txt', 'xlsx', 'xls'].contains(extension.toLowerCase());
  }

  String _generateErrorMessage(List<FileValidationError> errors) {
    if (errors.isEmpty) return '';

    final messages = <String>[];
    for (final error in errors) {
      switch (error) {
        case FileValidationError.invalidExtension:
          messages.add('File type not allowed');
          break;
        case FileValidationError.invalidMimeType:
          messages.add('Invalid file format');
          break;
        case FileValidationError.invalidMagicNumber:
          messages.add('File appears to be corrupted or not a valid file');
          break;
        case FileValidationError.fileTooLarge:
          messages.add('File size exceeds maximum limit');
          break;
        case FileValidationError.filenameTooLong:
          messages.add('Filename is too long');
          break;
        case FileValidationError.filenameTooShort:
          messages.add('Filename is too short');
          break;
        case FileValidationError.dangerousExtension:
          messages.add('File type is potentially dangerous and not allowed');
          break;
        case FileValidationError.suspiciousFilename:
          messages.add('Filename contains suspicious patterns');
          break;
        case FileValidationError.cannotReadFile:
          messages.add('Cannot read file');
          break;
        case FileValidationError.emptyFile:
          messages.add('File is empty');
          break;
      }
    }

    return messages.join(', ');
  }
}
