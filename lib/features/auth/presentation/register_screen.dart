import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_time_watchlist/features/auth/repo/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ElevatedButton(
                  onPressed: () async {
                    // Handle login logic
                    final isSignedIn = await AuthService()
                        .signUpWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context,
                        );
                    if (isSignedIn) {
                      context.go('/login');
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Login failed')));
                    }
                  },
                  child: const Text('Login'),
                ),           
          ],
        ),
      ),
    );
  }
}