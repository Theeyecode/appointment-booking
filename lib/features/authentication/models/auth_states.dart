import 'package:appointment_booking_app/features/authentication/models/auth_results.dart';
import 'package:flutter/foundation.dart';

import '../../../core/typedefs/user_id.dart';

@immutable
class AuthState {
  final AuthResult? result;
  final UserId? userId;
  final bool isLoading;
  final bool userTypeSelectionRequired;
  const AuthState(
      {required this.result,
      required this.isLoading,
      required this.userId,
      required this.userTypeSelectionRequired});

  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null,
        userTypeSelectionRequired = false;

  AuthState copyWith({
    AuthResult? result,
    UserId? userId,
    bool? isLoading,
    bool? userTypeSelectionRequired,
  }) {
    return AuthState(
      result: result ?? this.result,
      userId: userId ?? this.userId,
      isLoading: isLoading ?? this.isLoading,
      userTypeSelectionRequired:
          userTypeSelectionRequired ?? this.userTypeSelectionRequired,
    );
  }

  AuthState copyWithIsLoading(bool isLoading) => AuthState(
      result: result,
      isLoading: isLoading,
      userId: userId,
      userTypeSelectionRequired: userTypeSelectionRequired);

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId &&
          userTypeSelectionRequired == other.userTypeSelectionRequired);

  @override
  int get hashCode =>
      Object.hash(result, isLoading, userId, userTypeSelectionRequired);
}
