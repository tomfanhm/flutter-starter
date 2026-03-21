import 'package:flutter/material.dart';

import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: const Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 400,
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
