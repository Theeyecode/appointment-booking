class TimeSlot {
  final String id;
  final DateTime start;
  final DateTime end;
  final DateTime date;
  bool booked;

  TimeSlot(
      {required this.id,
      required this.start,
      required this.end,
      required this.date,
      this.booked = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'date': date.toIso8601String(),
      'booked': booked
    };
  }

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
        id: map['id'],
        start: DateTime.parse(map['start']),
        end: DateTime.parse(map['end']),
        date: DateTime.parse(map['date']),
        booked: map['booked'] ?? false);
  }
  TimeSlot copyWith({
    String? id,
    DateTime? start,
    DateTime? end,
    DateTime? date,
    bool? booked,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      date: date ?? this.date,
      booked: booked ?? this.booked,
    );
  }
}
