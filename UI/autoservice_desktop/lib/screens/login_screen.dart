// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_desktop/models/storageService.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import '../providers/AuthProvider.dart';

class LoginScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const LoginScreen({Key? key, required this.authProvider}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _isLoading = false;

  bool _isLoginButtonEnabled() {
    return _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  Future<void> _login(BuildContext context) async {
    if (!_isLoginButtonEnabled() || _isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    StorageService? storageService =
        await widget.authProvider.login(username, password);

    if (storageService != null &&
        storageService.role == 'Admin' &&
        storageService.isActive == true) {
      Navigator.pushReplacementNamed(context, '/home',
          arguments: storageService);
    } else if (storageService != null &&
        storageService.role == 'Employee' &&
        storageService.isActive == true) {
      Navigator.pushReplacementNamed(context, '/home2',
          arguments: storageService);
    } else if (storageService == null) {
      setState(() {
        _errorText = 'Wrong username or password!';
        _isLoading = false;
      });
    } else if (storageService.isActive == false) {
      setState(() {
        _errorText = 'This account is not active!';
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorText = 'Invalid user role!';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png'),
                  TextField(
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                        labelText: "Username", prefixIcon: Icon(Icons.email)),
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    onChanged: (_) => setState(() {}),
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password)),
                    controller: _passwordController,
                  ),
                  if (_errorText.isNotEmpty)
                    Text(
                      _errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 50),
                              backgroundColor: secondaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              _login(context);
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
