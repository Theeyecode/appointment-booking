import 'package:appointment_booking_app/core/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String displayName;
  final String? email;
  final UserType userType; // Add the userType enum

  UserModel({
    required this.id,
    required this.displayName,
    this.email,
    required this.userType, // Require userType in the constructor
  });

  // From Firestore document to UserModel
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      displayName: doc['displayName'],
      email: doc['email'],
      userType: UserType.values
          .firstWhere((e) => e.toString().split('.').last == doc['userType']),
    );
  }

  // UserModel to Firestore document data
  Map<String, dynamic> toDocument() {
    return {
      'displayName': displayName,
      'email': email,
      'userType':
          userType.toString().split('.').last, // Store the userType as a string
    };
  }
}
