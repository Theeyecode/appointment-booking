import 'package:appointment_booking_app/features/customer/models/customer.dart';
import 'package:appointment_booking_app/features/merchants/models/merchants.dart';
import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final Merchant merchant;
  final Customer customer;
  final String merchantId;
  final String customerId;
  final DateTime? createdAt;

  final TimeSlot timeSlot;

  Appointment({
    required this.id,
    required this.merchant,
    required this.customer,
    required this.merchantId,
    required this.customerId,
    required this.createdAt,
    required this.timeSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': Timestamp.fromDate(createdAt!),
      'merchant': merchant.toMap(),
      'customer': customer.toMap(),
      'timeSlot': timeSlot.toMap(),
      'merchantId': merchantId,
      'customerId': customerId,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
        id: map['id'] ?? '',
        merchant: Merchant.fromMap(map['merchant']),
        customer: Customer.fromMap(map['customer']),
        merchantId: map['merchantId'],
        customerId: map['customerId'],
        createdAt: (map['created_at'] as Timestamp).toDate(),
        timeSlot: TimeSlot.fromMap(map['timeSlot']));
  }
}
