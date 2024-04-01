// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appointment_booking_app/features/authentication/data/auth_abstract.dart';
import 'package:appointment_booking_app/providers/customer_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appointment_booking_app/core/user_type.dart';
import 'package:appointment_booking_app/features/authentication/data/auth_backend.dart';
import 'package:appointment_booking_app/features/authentication/models/auth_results.dart';
import 'package:appointment_booking_app/features/authentication/models/auth_states.dart';
import 'package:appointment_booking_app/features/dashboard/presentation/views/homescreen.dart';
import 'package:appointment_booking_app/features/merchants/presentation/views/merchant_dashboard.dart';
import 'package:appointment_booking_app/features/user/data/user_backend.dart';
import 'package:appointment_booking_app/features/user/models/user.dart';
import 'package:appointment_booking_app/providers/merchant_providers.dart';
import 'package:appointment_booking_app/shared/show_toast.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final IAuthenticator _authenticator;
  final UserManagement _userManagement;

  Ref ref;

  AuthStateNotifier(this._authenticator, this._userManagement, this.ref)
      : super(const AuthState.unknown());

  Future<void> logOut() async {
    state = state.copyWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }

  UserModel? _userModel;
  UserModel? get userModel => _userModel;
  Future<void> loginWithGoogle(BuildContext context) async {
    state = state.copyWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    if (result == AuthResult.success) {
      final userId = _authenticator.userId;
      if (userId != null) {
        UserModel? user = await _userManagement.getUser(userId);
        bool userTypeSelectionRequired = user?.userType == UserType.unKnown;
        if (user == null) {
          print('Got to user == null');
          user = UserModel(
            id: userId,
            displayName: _authenticator.displayName,
            email: _authenticator.email,
            userType: UserType.unKnown,
          );
          await _userManagement.createUser(user);
          // This is a new user, so we need userType selection
          userTypeSelectionRequired = true;
        }
        print('Got to user != null');
        // Update userModel in state
        _userModel = user;
        // Update state to reflect the successful login
        state = AuthState(
          result: result,
          isLoading: false,
          userId: userId,
          userTypeSelectionRequired: userTypeSelectionRequired,
        );
        if (!userTypeSelectionRequired) {
          navigateBasedOnUserType1(context);
        } else {
          Navigator.pushReplacementNamed(context, '/userTypeSelection');
        }
      }
    } else {
      // Handle login failure
      state = AuthState(
          result: result,
          isLoading: false,
          userId: null,
          userTypeSelectionRequired: false);
    }
  }

  void navigateBasedOnUserType1(BuildContext context) async {
    final userType = userModel?.userType ?? UserType.unKnown;
    switch (userType) {
      case UserType.merchant:
        await ref!
            .read(merchantProvider.notifier)
            .fetchOrCreateMerchant(state.userId!);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const MerchantDashboardScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case UserType.customer:
        await ref!
            .read(customerProvider.notifier)
            .fetchOrCreateCustomer(state.userId!);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
        break;
      case UserType.unKnown:
      default:
        Navigator.pushReplacementNamed(context, '/userTypeSelection');
        break;
    }
  }

  Future<void> registerWithEmailPassword(
      String email, String password, String name) async {
    state = state.copyWithIsLoading(true);
    final result =
        await _authenticator.registerWithEmailPassword(email, password);
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    final dname = FirebaseAuth.instance.currentUser?.displayName ?? name;
    if (result == AuthResult.success) {
      final user = UserModel(
        id: _authenticator.userId!,
        displayName: dname,
        email: email,
        userType: UserType.unKnown,
      );

      final success = await _userManagement.createUser(user);
      _userModel = user;

      if (success) {
        state = AuthState(
            result: result,
            isLoading: false,
            userId: user.id,
            userTypeSelectionRequired: true);
      } else {
        state = const AuthState(
            result: AuthResult.failure,
            isLoading: false,
            userId: null,
            userTypeSelectionRequired: false);
      }
    } else {
      state = AuthState(
          result: result,
          isLoading: false,
          userId: null,
          userTypeSelectionRequired: false);
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    state = state.copyWithIsLoading(true);
    final result =
        await _authenticator.signInWithEmailPassword(email, password);
    if (result == AuthResult.success) {
      final userId = _authenticator.userId;
      try {
        _userModel = await _userManagement.getUser(userId!);

        bool userTypeSelectionRequired =
            _userModel?.userType == UserType.unKnown || _userModel == null;
        state = state.copyWith(
          result: AuthResult.success,
          isLoading: false,
          userId: userId,
          userTypeSelectionRequired: userTypeSelectionRequired,
        );
      } catch (e) {
        state = state.copyWith(
            result: AuthResult.success,
            isLoading: false,
            userId: userId,
            userTypeSelectionRequired: false);
      }
    } else {
      state = state.copyWith(
          result: AuthResult.success,
          isLoading: false,
          userId: null,
          userTypeSelectionRequired: false);
    }
  }

  // Example role selection method
  Future<bool> selectRole(UserType selectedRole, BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      
      final updatedUser = UserModel(
        id: currentUser.uid,
        displayName: currentUser.displayName ?? 'No Name',
        email: currentUser.email ?? '',
        userType: selectedRole,
      );


      // Update the user in Firestore and wait for completion.
      await _userManagement.updateUser(updatedUser);
      UserModel? fetchedUser = await _userManagement.getUser(currentUser.uid);
 

      if (fetchedUser != null) {

        _userModel = fetchedUser;
        state = state.copyWith(userTypeSelectionRequired: false);

        if (selectedRole == UserType.merchant) {
       
          await ref.read(merchantProvider.notifier).fetchOrCreateMerchant(
              fetchedUser.id,
              name: fetchedUser.displayName);
        
        } else if (selectedRole == UserType.customer) {
          await ref.read(customerProvider.notifier).fetchOrCreateCustomer(
              fetchedUser.id,
              name: fetchedUser.displayName);
        } else {
          print("Ref is null or user type is not selected.");
        }

        return true;
      } else {
        showErrorToast("Failed to update user role, please try again.");
        return false;
      }
    }
    print('three');
    return false;
  }
}
