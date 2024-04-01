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

class CustomerBookingDetail {
  final String appointmentId;
  final String customerName;
  final TimeSlot timeSlot;

  CustomerBookingDetail({
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

  factory CustomerBookingDetail.fromMap(Map<String, dynamic> map) {
    return CustomerBookingDetail(
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

class MerchantBookingDetail {
  final String appointmentId;
  final String merchantName;
  final TimeSlot timeSlot;

  MerchantBookingDetail({
    required this.appointmentId,
    required this.merchantName,
    required this.timeSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'customerName': merchantName,
      'timeSlot': timeSlot.toMap(),
    };
  }

  factory MerchantBookingDetail.fromMap(Map<String, dynamic> map) {
    return MerchantBookingDetail(
      appointmentId: map['appointmentId'],
      merchantName: map['merchantName'],
      timeSlot: TimeSlot.fromMap(map['timeSlot']),
    );
  }

  @override
  String toString() {
    return 'Appointment with $merchantName for ${timeSlot.toString()}';
  }
}
