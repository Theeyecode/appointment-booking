import 'package:appointment_booking_app/features/authentication/presentation/views/login_screen.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/shared/loading/loading_screen.dart';
import 'package:appointment_booking_app/shared/show_toast.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/share.dart';
// Import your AuthStateNotifier

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late TextEditingController lastnameController;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    lastnameController = TextEditingController();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    lastnameController.dispose();

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your account has been created successfully.'),
                Text('Please login to continue.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Login'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                Navigator.of(context)
                    .pushReplacementNamed('/login'); // Navigate to login screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                const SizedBox(height: 10),

                MyTextField(
                  controller: lastnameController,
                  hintText: 'name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: 'email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  title: 'Sign up',
                  onTap: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final name = lastnameController.text.trim();

                    if (email.isNotEmpty &&
                        password.isNotEmpty &&
                        name.isNotEmpty) {
                      try {
                        LoadingScreen.instance()
                            .show(context: context); // Show loading
                        await authState.registerWithEmailPassword(
                            email, password, name);
                        // Hide loading and show congratulations message
                        LoadingScreen.instance().hide();
                        _showCongratulationsDialog();
                      } catch (e) {
                        LoadingScreen.instance().hide();
                        showErrorToast("Failed to register.");
                      }
                    } else {
                      showErrorToast("Please fill in all fields.");
                    }
                  },
                ),

                const SizedBox(height: 50),

                // or continue wit

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
