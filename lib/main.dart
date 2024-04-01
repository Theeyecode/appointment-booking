import 'package:appointment_booking_app/features/dashboard/presentation/views/homescreen.dart';

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
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomePage(),
          '/userTypeSelection': (context) => const UserTypeScreen(),
        },
        // Initial route
        initialRoute: '/login',
        home: const LoginScreen(),
      ),
    );
  }
}
