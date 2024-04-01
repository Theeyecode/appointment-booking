import 'package:flutter/material.dart';

enum TimeSelectionType { startTime, endTime }

Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  required DateTime pickedDate,
  required TimeSelectionType selectionType,
}) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final isToday = pickedDate.isAtSameMomentAs(today);
  final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);

  // Title based on selection type
  String title = selectionType == TimeSelectionType.startTime
      ? "Select Start Time"
      : "Select End Time";

  // Initial and earliest time considerations
  TimeOfDay initialTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay? earliestTime;
  if (isToday) {
    initialTime = nowTime;
    earliestTime = nowTime;
  }

  // Custom time picker dialog
  return showDialog<TimeOfDay>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 24,
            itemBuilder: (context, index) {
              final hour = index + 1; // 1 to 24
              final time = TimeOfDay(hour: hour % 24, minute: 0);
              final isEnabled = earliestTime == null ||
                  hour > earliestTime.hour ||
                  (!isToday && hour >= 1); // Enable all future hours
              return ListTile(
                title: Text(time.format(context)),
                enabled: isEnabled,
                onTap: isEnabled
                    ? () {
                        Navigator.of(context).pop(time);
                      }
                    : null,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
