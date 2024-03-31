import 'package:appointment_booking_app/features/dashboard/presentation/views/homescreen.dart';
import 'package:appointment_booking_app/features/merchants/presentation/views/merchant_dashboard.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/providers/is_loading.dart';

import 'package:appointment_booking_app/shared/loading/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/authentication/presentation/views/login_screen.dart';
import 'features/authentication/presentation/views/user_type_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        //  Define routes
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomePage(),
          '/userTypeSelection': (context) => const UserTypeScreen(),
        },
        // Initial route
        initialRoute: '/login',
        home: const LoginScreen(),
      ),
    );
  }
}

class AuthManager extends ConsumerWidget {
  const AuthManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authStateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.userId != null && !authState.userTypeSelectionRequired) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (authState.userId == null) {
        // If not logged in, ensure we're on the login screen
        // Assuming '/login' is not already the current route
        if (ModalRoute.of(context)?.settings.name != '/login') {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
      // Do not automatically navigate to '/userTypeSelection' or '/login' after registration
      // Handle those navigations manually based on user actions
    });

    // Return a placeholder or the current screen's widget
    return Container();
  }
}
