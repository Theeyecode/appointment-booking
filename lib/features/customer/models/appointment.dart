class Appointment {
  final String merchantId;
  final String timeSlotId;

  Appointment({
    required this.merchantId,
    required this.timeSlotId,
  });

  Map<String, dynamic> toMap() {
    return {
      'merchantId': merchantId,
      'timeSlotId': timeSlotId,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      merchantId: map['merchantId'],
      timeSlotId: map['timeSlotId'],
    );
  }
}
