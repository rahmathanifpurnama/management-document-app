import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TestGoogleAuth extends StatefulWidget {
  const TestGoogleAuth({super.key});

  @override
  State<TestGoogleAuth> createState() => _TestGoogleAuthState();
}

class _TestGoogleAuthState extends State<TestGoogleAuth> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/drive.file'],
  );

  GoogleSignInAccount? _currentUser;
  String _status = 'Not signed in';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
        _status = account != null
            ? 'Signed in as ${account.email}'
            : 'Not signed in';
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      setState(() => _status = 'Signing in...');
      final account = await _googleSignIn.signIn();
      if (account != null) {
        setState(() => _status = 'Signed in as ${account.email}');

        // Test Google Drive access
        final auth = await account.authentication;
        setState(
          () => _status =
              'Signed in as ${account.email}\nAccess Token: ${auth.accessToken?.substring(0, 20)}...',
        );
      } else {
        setState(() => _status = 'Sign in cancelled');
      }
    } catch (error) {
      setState(() => _status = 'Sign in failed: $error');
      debugPrint('Google Sign-In Error: $error');
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() => _status = 'Signed out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Google Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Status: $_status',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_currentUser == null)
              ElevatedButton(
                onPressed: _handleSignIn,
                child: const Text('Sign In with Google'),
              )
            else
              Column(
                children: [
                  Text('Welcome, ${_currentUser!.displayName}!'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _handleSignOut,
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
