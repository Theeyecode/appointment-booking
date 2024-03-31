import 'package:appointment_booking_app/features/authentication/models/auth_results.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.result == AuthResult.success;
});
