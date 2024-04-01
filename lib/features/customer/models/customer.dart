import 'package:appointment_booking_app/features/customer/models/appointment.dart';

class Customer {
  final String id;
  final String name;
  List<Appointment>? appointments;

  Customer({
    required this.id,
    required this.name,
    this.appointments,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'appointments': appointments?.map((a) => a.toMap()).toList(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      appointments: map['appointments'] != null
          ? List<Appointment>.from(
              map['appointments'].map((a) => Appointment.fromMap(a)))
          : [],
    );
  }
}
