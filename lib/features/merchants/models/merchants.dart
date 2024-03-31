import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';

class Merchant {
  final String id;
  final String name;
  List<TimeSlot>? availableTimeSlots;

  Merchant({
    required this.id,
    required this.name,
    this.availableTimeSlots,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'availableTimeSlots':
          availableTimeSlots?.map((slot) => slot.toMap()).toList(),
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
      id: map['id'],
      name: map['name'],
      availableTimeSlots: map['availableTimeSlots'] != null
          ? List<TimeSlot>.from(
              map['availableTimeSlots'].map((slot) => TimeSlot.fromMap(slot)))
          : null,
    );
  }

  Merchant copyWith({
    String? id,
    String? name,
    List<TimeSlot>? availableTimeSlots,
  }) {
    return Merchant(
      id: id ?? this.id,
      name: name ?? this.name,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
    );
  }
}
