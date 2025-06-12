import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget to display App Check error with specific instructions
class AppCheckErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const AppCheckErrorWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isTooManyAttempts = errorMessage.contains('Too many attempts');
    
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isTooManyAttempts ? Icons.warning : Icons.error,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isTooManyAttempts 
                        ? 'App Check Rate Limited' 
                        : 'App Check Error',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (isTooManyAttempts) ...[
              const Text(
                'Firebase is blocking requests due to too many attempts. This happens when the debug token is not configured.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🚨 IMMEDIATE ACTION REQUIRED:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Copy the debug token below'),
                    const Text('2. Add it to Firebase Console'),
                    const Text('3. Wait 5-10 minutes'),
                    const Text('4. Restart the app'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Debug Token:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Expanded(
                          child: SelectableText(
                            '0D5038C4-B4F2-4628-8AD4-D500B904BA04',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _copyToken(context),
                          icon: const Icon(Icons.copy, size: 18),
                          tooltip: 'Copy token',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Firebase Console Steps:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Open Firebase Console'),
                    const Text('2. Select project: document-management-c5a96'),
                    const Text('3. Go to App Check'),
                    const Text('4. Find your Android app'),
                    const Text('5. Click "Debug tokens" → "Add debug token"'),
                    const Text('6. Paste the token and save'),
                  ],
                ),
              ),
            ] else ...[
              Text(
                'Error: $errorMessage',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please check your Firebase configuration and try again.',
                style: TextStyle(fontSize: 14),
              ),
            ],
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                if (onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _openFirebaseConsole(),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Firebase Console'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToken(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: '0D5038C4-B4F2-4628-8AD4-D500B904BA04'));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Debug token copied! Now add it to Firebase Console.'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openFirebaseConsole() {
    // This would open the Firebase Console in a browser
    // For now, we'll just show a message
    debugPrint('Opening Firebase Console: https://console.firebase.google.com/');
  }
}
