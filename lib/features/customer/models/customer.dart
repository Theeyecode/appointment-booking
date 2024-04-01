import 'package:appointment_booking_app/features/customer/models/appointment.dart';

class Customer {
  final String id;
  final String name;

  Customer({
    required this.id,
    required this.name,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
    );
  }
}
