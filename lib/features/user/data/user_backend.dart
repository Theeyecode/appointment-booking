import 'package:appointment_booking_app/features/user/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createUser(UserModel user) async {
    try {
      // Check if user already exists
      final existingUser =
          await _firestore.collection('users').doc(user.id).get();
      if (existingUser.exists) {
        // Update if exists
        await existingUser.reference.update(user.toDocument());
      } else {
        // Create new if doesn't exist
        await _firestore
            .collection('users')
            .doc(user.id)
            .set(user.toDocument());
      }
      return true;
    } catch (e) {
      print("Error creating user: $e");
      return false;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromDocument(userDoc);
      }
      return null;
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      // Directly attempt to update the user document with provided user model data
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.toDocument());
      return true;
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }
}
