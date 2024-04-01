import 'package:appointment_booking_app/features/authentication/data/auth_backend.dart';
import 'package:appointment_booking_app/features/authentication/presentation/notifiers/auth_notifiers.dart';
import 'package:appointment_booking_app/features/user/data/user_backend.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/authentication/models/auth_states.dart';
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(Authenticator(), UserManagement(), ref);
});
