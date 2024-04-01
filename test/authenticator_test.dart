// Import your test dependencies
import 'package:appointment_booking_app/features/authentication/data/auth_abstract.dart';
import 'package:appointment_booking_app/features/authentication/models/auth_states.dart';
import 'package:appointment_booking_app/features/authentication/presentation/notifiers/auth_notifiers.dart';
import 'package:appointment_booking_app/features/user/data/user_backend.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authenticator_test.mocks.dart';

// Annotation to generate mocks
@GenerateMocks([IAuthenticator, UserManagement, ProviderRef])
void main() {
  group('AuthStateNotifier Tests', () {
    late MockIAuthenticator mockAuthenticator;
    late MockUserManagement mockUserManagement;
    late MockProviderRef mockRef; // Mock for Riverpod's Ref, if needed

    // Declare the class under test
    late AuthStateNotifier authStateNotifier;

    setUp(() {
      // Initialize your mocks
      mockAuthenticator = MockIAuthenticator();
      mockUserManagement = MockUserManagement();
      mockRef = MockProviderRef();

      // Initialize AuthStateNotifier with mocks
      authStateNotifier =
          AuthStateNotifier(mockAuthenticator, mockUserManagement, mockRef);
    });
    test('should log out correctly', () async {
      when(mockAuthenticator.logOut()).thenAnswer((_) async => null);

      await authStateNotifier.logOut();

      verify(mockAuthenticator.logOut())
          .called(1); // Verify logOut was called once
      expect(authStateNotifier.state, equals(const AuthState.unknown()));
    });
  });
}
