import 'package:appointment_booking_app/core/typedefs/user_id.dart';
import 'package:appointment_booking_app/features/authentication/models/auth_results.dart';

abstract class IAuthenticator {
  UserId? get userId;
  bool get isAlreadyLoggedIn;
  String get displayName;
  String? get email;

  Future<void> logOut();
  Future<AuthResult> loginWithGoogle();
  Future<AuthResult> registerWithEmailPassword(String email, String password);
  Future<AuthResult> signInWithEmailPassword(String email, String password);
}
