// Simple validation script to check CSV support implementation
import 'lib/core/config/file_config.dart';
import 'lib/utils/file_icon_helper.dart';

void main() {
  print('=== CSV File Support Validation ===\n');
  
  // Test 1: Check if CSV is in allowed extensions
  print('1. CSV in allowed extensions: ${FileConfig.allowedExtensions.contains('csv')}');
  
  // Test 2: Check MIME type mapping
  print('2. CSV MIME type: ${FileConfig.getMimeType('test.csv')}');
  
  // Test 3: Check file type category
  print('3. CSV category: ${FileConfig.getFileTypeCategory('test.csv')}');
  
  // Test 4: Check display name
  print('4. CSV display name: ${FileConfig.getFileTypeDisplayName('test.csv')}');
  
  // Test 5: Check file icon
  print('5. CSV icon: ${FileIconHelper.getFileIcon('test.csv')}');
  print('   Excel icon: ${FileIconHelper.getFileIcon('test.xlsx')}');
  print('   Icons are different: ${FileIconHelper.getFileIcon('test.csv') != FileIconHelper.getFileIcon('test.xlsx')}');
  
  // Test 6: Check file categories
  print('6. CSV category: ${FileIconHelper.getFileCategory('test.csv')}');
  print('   Excel category: ${FileIconHelper.getFileCategory('test.xlsx')}');
  
  // Test 7: Check file colors
  print('7. CSV color: ${FileIconHelper.getFileTypeColor('test.csv')}');
  print('   Excel color: ${FileIconHelper.getFileTypeColor('test.xlsx')}');
  
  print('\n=== All Extensions Check ===');
  print('Allowed extensions: ${FileConfig.allowedExtensions}');
  
  print('\n=== File Type Groups ===');
  FileConfig.fileTypeGroups.forEach((key, value) {
    print('$key: $value');
  });
  
  print('\n=== Validation Complete ===');
}
