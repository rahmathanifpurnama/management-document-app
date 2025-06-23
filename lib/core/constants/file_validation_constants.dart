class FileValidationConstants {
  // Maximum file sizes (in bytes)
  static const int maxFileSizeGeneral = 10 * 1024 * 1024; // 10MB
  static const int maxFileSizeImage = 5 * 1024 * 1024; // 5MB
  static const int maxFileSizeDocument = 15 * 1024 * 1024; // 15MB
  static const int maxFileSizePresentation = 20 * 1024 * 1024; // 20MB

  // Allowed file extensions
  static const List<String> allowedExtensions = [
    'pdf',
    'doc',
    'docx',
    'pptx',
    'txt',
    'jpg',
    'jpeg',
    'png',
    'xlsx',
    'xls',
    'csv',
  ];

  // Allowed MIME types
  static const Map<String, List<String>> allowedMimeTypes = {
    'pdf': ['application/pdf'],
    'doc': ['application/msword'],
    'docx': [
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    ],
    'pptx': [
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    ],
    'txt': ['text/plain'],
    'jpg': ['image/jpeg'],
    'jpeg': ['image/jpeg'],
    'png': ['image/png'],
    'xlsx': [
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    ],
    'xls': ['application/vnd.ms-excel'],
    'csv': ['text/csv', 'application/csv', 'text/comma-separated-values'],
  };

  // File magic numbers (first few bytes) for validation
  static const Map<String, List<List<int>>> fileMagicNumbers = {
    'pdf': [
      [0x25, 0x50, 0x44, 0x46], // %PDF
    ],
    'jpg': [
      [0xFF, 0xD8, 0xFF], // JPEG
    ],
    'jpeg': [
      [0xFF, 0xD8, 0xFF], // JPEG
    ],
    'png': [
      [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A], // PNG
    ],
    'doc': [
      [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1], // MS Office
    ],
    'docx': [
      [0x50, 0x4B, 0x03, 0x04], // ZIP (Office Open XML)
      [0x50, 0x4B, 0x05, 0x06], // ZIP (Office Open XML)
      [0x50, 0x4B, 0x07, 0x08], // ZIP (Office Open XML)
    ],
    'pptx': [
      [0x50, 0x4B, 0x03, 0x04], // ZIP (Office Open XML)
      [0x50, 0x4B, 0x05, 0x06], // ZIP (Office Open XML)
      [0x50, 0x4B, 0x07, 0x08], // ZIP (Office Open XML)
    ],
    'xlsx': [
      [0x50, 0x4B, 0x03, 0x04], // ZIP (Office Open XML)
      [0x50, 0x4B, 0x05, 0x06], // ZIP (Office Open XML)
      [0x50, 0x4B, 0x07, 0x08], // ZIP (Office Open XML)
    ],
    'xls': [
      [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1], // MS Office
    ],
  };

  // Dangerous file extensions that should never be allowed
  static const List<String> dangerousExtensions = [
    'exe',
    'bat',
    'cmd',
    'com',
    'pif',
    'scr',
    'vbs',
    'js',
    'jar',
    'app',
    'deb',
    'pkg',
    'rpm',
    'dmg',
    'iso',
    'msi',
    'apk',
    'ipa',
    'sh',
    'ps1',
    'php',
    'asp',
    'aspx',
    'jsp',
    'py',
    'rb',
    'pl',
    'cgi',
    'htaccess',
    'sql',
  ];

  // Suspicious file name patterns
  static const List<String> suspiciousPatterns = [
    r'\.exe\.',
    r'\.scr\.',
    r'\.bat\.',
    r'\.cmd\.',
    r'\.com\.',
    r'\.pif\.',
    r'\.vbs\.',
    r'\.js\.',
    r'\.jar\.',
    r'script',
    r'malware',
    r'virus',
    r'trojan',
    r'backdoor',
    r'keylogger',
    r'rootkit',
  ];

  // Maximum filename length
  static const int maxFilenameLength = 255;

  // Minimum filename length
  static const int minFilenameLength = 1;

  // File size limits per type
  static Map<String, dynamic> getMaxFileSizeForExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return {'size': maxFileSizeImage, 'type': 'Image'};
      case 'pdf':
      case 'doc':
      case 'docx':
      case 'txt':
        return {'size': maxFileSizeDocument, 'type': 'Document'};
      case 'pptx':
        return {'size': maxFileSizePresentation, 'type': 'Presentation'};
      case 'xlsx':
      case 'xls':
        return {'size': maxFileSizeDocument, 'type': 'Spreadsheet'};
      default:
        return {'size': maxFileSizeGeneral, 'type': 'File'};
    }
  }
}
