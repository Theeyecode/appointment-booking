import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';

class Appointment {
  final String id;
  final String merchantId;
  final String customerId;
  final String timeSlotId;

  Appointment({
    required this.id,
    required this.merchantId,
    required this.customerId,
    required this.timeSlotId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'merchantId': merchantId,
      'customerId': customerId,
      'timeSlotId': timeSlotId,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] ?? '',
      merchantId: map['merchantId'],
      customerId: map['customerId'],
      timeSlotId: map['timeSlotId'],
    );
  }
}

class AppointmentDetail {
  final String appointmentId;
  final String customerName;
  final TimeSlot timeSlot;

  AppointmentDetail({
    required this.appointmentId,
    required this.customerName,
    required this.timeSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'customerName': customerName,
      'timeSlot': timeSlot.toMap(),
    };
  }

  factory AppointmentDetail.fromMap(Map<String, dynamic> map) {
    return AppointmentDetail(
      appointmentId: map['appointmentId'],
      customerName: map['customerName'],
      timeSlot: TimeSlot.fromMap(map['timeSlot']),
    );
  }

  @override
  String toString() {
    return 'Appointment with $customerName for ${timeSlot.toString()}';
  }
}
