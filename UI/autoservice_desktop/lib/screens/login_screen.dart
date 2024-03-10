import 'package:autoservice_desktop/models/storageService.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  bool _isLoginButtonEnabled() {
    return _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  Future<void> _login(BuildContext context) async {
    if (!_isLoginButtonEnabled()) {
      return;
    }

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    StorageService? storageService =
        await widget.authProvider.login(username, password);

    if (storageService != null && storageService.role == 'Admin') {
      Navigator.pushReplacementNamed(context, '/home',
          arguments: storageService);
    } else if (storageService != null && storageService.role == 'Employee') {
      Navigator.pushReplacementNamed(context, '/home2',
          arguments: storageService);
    } else {
      setState(() {
        _errorText = 'Invalid user role';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.network(
                      "https://mir-s3-cdn-cf.behance.net/project_modules/hd/3b7b527518607.560acd8ccb0e9.jpg"),
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
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed:
                        _isLoginButtonEnabled() ? () => _login(context) : null,
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
