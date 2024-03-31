import 'package:appointment_booking_app/core/typedefs/user_id.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userIdProvider =
    Provider<UserId?>((ref) => ref.watch(authStateProvider).userId);
