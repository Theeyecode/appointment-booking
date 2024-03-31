import 'package:appointment_booking_app/core/typedefs/user_id.dart';
import 'package:appointment_booking_app/features/authentication/constants/constants.dart';
import 'package:appointment_booking_app/features/authentication/models/auth_results.dart';
import 'package:appointment_booking_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticator {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
    scopes: [Constants.emailScope],
  );

  UserId? get userId => _firebaseAuth.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName => _firebaseAuth.currentUser?.displayName ?? "";
  String? get email => _firebaseAuth.currentUser?.email;

  Authenticator();

  // Logout
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.disconnect();
  }

  // Google Login
  Future<AuthResult> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if (signInAccount == null) {
        return AuthResult.aborted;
      }
      final GoogleSignInAuthentication googleAuth =
          await signInAccount.authentication;
      final AuthCredential authCredentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(authCredentials);
      return AuthResult.success;
    } catch (e) {
      print("Error during Google sign-in: $e");
      return AuthResult.failure;
    }
  }

  // Email/Password Registration
  Future<AuthResult> registerWithEmailPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthResult.success;
    } catch (e) {
      print("Error during email/password registration: $e");
      return AuthResult.failure;
    }
  }

  // Email/Password Sign In
  Future<AuthResult> signInWithEmailPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthResult.success;
    } on FirebaseAuthException catch (ex) {
      print("error occured due to ${ex.code.toString()}");
      return AuthResult.failure;
    }
  }
}
