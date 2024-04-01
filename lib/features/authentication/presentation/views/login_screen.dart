// ignore_for_file: use_build_context_synchronously

import 'package:appointment_booking_app/core/user_type.dart';

import 'package:appointment_booking_app/features/authentication/presentation/views/register_screen.dart';

import 'package:appointment_booking_app/features/dashboard/presentation/views/homescreen.dart';
import 'package:appointment_booking_app/features/merchants/presentation/views/merchant_dashboard.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/providers/merchant_providers.dart';
import 'package:appointment_booking_app/shared/loading/loading_screen.dart';
import 'package:appointment_booking_app/shared/show_toast.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/share.dart';
// Import your AuthStateNotifier

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorToast("Please fill in all fields");
      return;
    }

    try {
      setState(() => isLoading = true);
      LoadingScreen.instance().show(context: context);

      // Attempt to sign in.
      await ref
          .read(authStateProvider.notifier)
          .signInWithEmailPassword(email, password);

      // After signing in, determine the next step based on the current authentication state.
      final authState = ref.read(authStateProvider);

      // Assuming AuthState has a way to check if the user is logged in successfully.
      if (authState.userId != null) {
        navigateBasedOnUserType(authState.userId);
      } else {
        // Handle failed login attempt.
        showErrorToast("Login failed");
      }
    } catch (e) {
      showErrorToast("Login failed: $e");
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
      LoadingScreen.instance().hide();
    }
  }

  void navigateBasedOnUserType(String? userId) async {
    final userType = ref.read(authStateProvider.notifier).userModel?.userType ??
        UserType.unKnown;
    switch (userType) {
      case UserType.merchant:
        await ref
            .read(merchantProvider.notifier)
            .fetchOrCreateMerchant(userId!);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const MerchantDashboardScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case UserType.customer:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
        break;
      case UserType.unKnown:
      default:
        Navigator.pushReplacementNamed(context, '/userTypeSelection');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
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
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'appointment@email.com',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  title: "Sign In",
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    handleLogin();
                    // Dismiss the keyboard
                  },
                ),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    GestureDetector(
                      onTap: () async {
                        try {
                          // Show loading screen
                          LoadingScreen.instance().show(context: context);

                          // Perform Google sign-in
                          await ref
                              .read(authStateProvider.notifier)
                              .loginWithGoogle(context);
                          final userType = ref
                                  .read(authStateProvider.notifier)
                                  .userModel
                                  ?.userType ??
                              UserType.unKnown;

                          if (authState.userId != null) {
                            if (authState.userTypeSelectionRequired) {
                              Navigator.pushReplacementNamed(
                                  context, '/userTypeSelection');
                            } else if (!authState.userTypeSelectionRequired &&
                                userType == UserType.merchant) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        const MerchantDashboardScreen()),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        HomePage()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          }
                        } catch (e) {
                          showErrorToast("Failed to sign in with Google.");
                        } finally {
                          // Hide loading screen
                          LoadingScreen.instance().hide();
                        }
                      },
                      child: const SquareTile(
                          imagePath:
                              '/Users/emmanuelolajubu/appointment_booking_app/assets/pngs/google.png'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: const Text(
                        'Register now',
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
