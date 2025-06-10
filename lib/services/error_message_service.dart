/// Centralized error message service for consistent error handling
class ErrorMessageService {
  // Upload error messages
  static const Map<String, String> uploadErrors = {
    'file_too_large': 'File size exceeds maximum limit of 15MB',
    'invalid_extension': 'File type is not supported',
    'upload_cancelled': 'Upload was cancelled - please try again',
    'authentication_required': 'Please log in again and try again',
    'network_error': 'Network error - please check your internet connection',
    'permission_denied': 'Access denied - please check permissions',
    'storage_error': 'Storage error - please try again',
    'upload_timeout': 'Upload timeout - try a smaller file',
    'quota_exceeded': 'Storage quota exceeded',
    'validation_failed': 'File validation failed - please check file type',
    'file_corrupted': 'File was corrupted during upload - please try again',
    'cloud_functions_unavailable': 'Cloud functions are not available',
    'duplicate_file': 'File already exists in the system',
    'invalid_file_name': 'Invalid file name - please rename the file',
    'file_empty': 'File is empty or corrupted',
    'unsupported_format': 'File format is not supported',
  };

  // Validation error messages
  static const Map<String, String> validationErrors = {
    'filename_too_long': 'File name is too long (maximum 255 characters)',
    'filename_invalid_chars': 'File name contains invalid characters',
    'filename_empty': 'File name cannot be empty',
    'extension_missing': 'File must have a valid extension',
    'extension_dangerous': 'File type is potentially dangerous and not allowed',
    'file_suspicious': 'File appears to be suspicious or potentially harmful',
    'magic_number_mismatch': 'File content does not match its extension',
    'file_size_zero': 'File size cannot be zero',
    'file_size_negative': 'Invalid file size',
  };

  // Security error messages
  static const Map<String, String> securityErrors = {
    'malicious_content': 'File contains potentially malicious content',
    'virus_detected': 'File may contain a virus or malware',
    'script_detected': 'File contains executable scripts',
    'suspicious_header': 'File header appears to be suspicious',
    'encrypted_content': 'Encrypted files are not allowed',
    'password_protected': 'Password-protected files are not allowed',
  };

  // Network error messages
  static const Map<String, String> networkErrors = {
    'connection_timeout': 'Connection timeout - please check your internet',
    'server_unavailable': 'Server is temporarily unavailable',
    'connection_lost': 'Connection was lost during upload',
    'dns_error': 'Unable to resolve server address',
    'ssl_error': 'SSL/TLS connection error',
    'proxy_error': 'Proxy connection error',
  };

  /// Get error message by key
  static String getErrorMessage(String errorKey, {String? fallback}) {
    // Check upload errors first
    if (uploadErrors.containsKey(errorKey)) {
      return uploadErrors[errorKey]!;
    }
    
    // Check validation errors
    if (validationErrors.containsKey(errorKey)) {
      return validationErrors[errorKey]!;
    }
    
    // Check security errors
    if (securityErrors.containsKey(errorKey)) {
      return securityErrors[errorKey]!;
    }
    
    // Check network errors
    if (networkErrors.containsKey(errorKey)) {
      return networkErrors[errorKey]!;
    }
    
    // Return fallback or generic message
    return fallback ?? 'An unexpected error occurred';
  }

  /// Get user-friendly error message from exception
  static String getErrorFromException(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // File size errors
    if (errorString.contains('file size') || errorString.contains('too large')) {
      return getErrorMessage('file_too_large');
    }
    
    // Extension errors
    if (errorString.contains('extension') || errorString.contains('file type')) {
      return getErrorMessage('invalid_extension');
    }
    
    // Network errors
    if (errorString.contains('network') || errorString.contains('connection')) {
      return getErrorMessage('network_error');
    }
    
    // Authentication errors
    if (errorString.contains('auth') || errorString.contains('permission')) {
      return getErrorMessage('authentication_required');
    }
    
    // Duplicate errors
    if (errorString.contains('duplicate') || errorString.contains('already exists')) {
      return getErrorMessage('duplicate_file');
    }
    
    // Timeout errors
    if (errorString.contains('timeout')) {
      return getErrorMessage('upload_timeout');
    }
    
    // Storage errors
    if (errorString.contains('storage') || errorString.contains('quota')) {
      return getErrorMessage('storage_error');
    }
    
    // Return original error if no match found
    return error.toString();
  }

  /// Check if error is retryable
  static bool isRetryableError(String errorKey) {
    const retryableErrors = {
      'network_error',
      'connection_timeout',
      'server_unavailable',
      'connection_lost',
      'upload_timeout',
      'storage_error',
      'cloud_functions_unavailable',
    };
    
    return retryableErrors.contains(errorKey);
  }

  /// Get error severity level
  static ErrorSeverity getErrorSeverity(String errorKey) {
    const criticalErrors = {
      'malicious_content',
      'virus_detected',
      'authentication_required',
      'permission_denied',
    };
    
    const warningErrors = {
      'file_too_large',
      'invalid_extension',
      'duplicate_file',
      'quota_exceeded',
    };
    
    if (criticalErrors.contains(errorKey)) {
      return ErrorSeverity.critical;
    } else if (warningErrors.contains(errorKey)) {
      return ErrorSeverity.warning;
    } else {
      return ErrorSeverity.info;
    }
  }
}

/// Error severity levels
enum ErrorSeverity {
  info,
  warning,
  critical,
}
