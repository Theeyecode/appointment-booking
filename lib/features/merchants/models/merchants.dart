import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Merchant {
  final String id;
  final String name;
  final DateTime? createdAt;
  List<TimeSlot>? availableTimeSlots;

  Merchant({
    required this.id,
    required this.name,
    required this.createdAt,
    this.availableTimeSlots,
  });

  TimeSlot? getTimeSlotById(String timeSlotId) {
    final x = availableTimeSlots?.firstWhere(
      (slot) => slot.id == timeSlotId,
    );
    if (x == null) {
      print('It was null here');
      return null;
    } else {
      return x;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': Timestamp.fromDate(createdAt!),
      'availableTimeSlots':
          availableTimeSlots?.map((slot) => slot.toMap()).toList(),
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
      id: map['id'],
      name: map['name'],
      createdAt: (map['created_at'] as Timestamp).toDate(),
      availableTimeSlots: map['availableTimeSlots'] != null
          ? List<TimeSlot>.from(
              map['availableTimeSlots'].map((slot) => TimeSlot.fromMap(slot)))
          : null,
    );
  }

  Merchant copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    List<TimeSlot>? availableTimeSlots,
  }) {
    return Merchant(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
    );
  }
}
