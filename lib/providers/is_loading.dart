import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.isLoading;
});
