// ignore_for_file: use_build_context_synchronously

import 'package:appointment_booking_app/core/app/app_colors.dart';
import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';
import 'package:appointment_booking_app/features/merchants/presentation/views/show_custom.dart';
import 'package:appointment_booking_app/providers/merchant_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ManageAvailabilityScreen extends ConsumerStatefulWidget {
  const ManageAvailabilityScreen({super.key});

  @override
  ManageAvailabilityScreenState createState() =>
      ManageAvailabilityScreenState();
}

class ManageAvailabilityScreenState
    extends ConsumerState<ManageAvailabilityScreen> {
  List<TimeSlot> timeSlots = [];
  Map<String, List<TimeSlot>> groupTimeSlotsByDate(List<TimeSlot> slots) {
    Map<String, List<TimeSlot>> grouped = {};
    for (var slot in slots) {
      final dateKey = DateFormat('yyyy-MM-dd').format(slot.start);
      grouped.putIfAbsent(dateKey, () => []).add(slot);
    }
    return grouped;
  }

  Future<void> _addOrEditTimeSlot({
    TimeSlot? existingSlot,
    int? index,
    bool isFetched = false,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: existingSlot?.start ?? now,
      firstDate: today,
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedStartTime = await showCustomTimePicker(
      context: context,
      pickedDate: pickedDate,
      selectionType: TimeSelectionType.startTime,
    );

    if (pickedStartTime == null) return;

    final TimeOfDay? pickedEndTime = await showCustomTimePicker(
      context: context,
      pickedDate: pickedDate,
      selectionType: TimeSelectionType.endTime,
    );

    if (pickedEndTime == null ||
        pickedEndTime.hour < pickedStartTime.hour ||
        (pickedEndTime.hour == pickedStartTime.hour &&
            pickedEndTime.minute <= pickedStartTime.minute)) {
      Fluttertoast.showToast(
        msg: "Invalid time range selected.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    final DateTime startDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedStartTime.hour,
      pickedStartTime.minute,
    );

    final DateTime endDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedEndTime.hour,
      pickedEndTime.minute,
    );

    // Check for overlap
    bool hasOverlap(TimeSlot slot) {
      if (slot == existingSlot) {
        return false; // Skip the slot being edited
      }
      return slot.start.isBefore(endDateTime) &&
          slot.end.isAfter(startDateTime);
    }

    bool overlapsWithExisting =
        fetchedTimeSlots.any(hasOverlap) || newlyAddedTimeSlots.any(hasOverlap);

    if (overlapsWithExisting) {
      Fluttertoast.showToast(
        msg: "The selected time range overlaps with an existing time range.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    final TimeSlot newSlot = existingSlot?.copyWith(
            start: startDateTime, end: endDateTime, date: pickedDate) ??
        TimeSlot(
            id: const Uuid().v4(),
            start: startDateTime,
            end: endDateTime,
            date: pickedDate,
            booked: false);

    if (existingSlot != null && index != null) {
      if (isFetched) {
        fetchedTimeSlots[index] = newSlot;
      } else {
        newlyAddedTimeSlots[index] = newSlot;
      }
    } else {
      newlyAddedTimeSlots.add(newSlot);
    }

    setState(() {}); // Trigger a rebuild with the updated state
  }

  List<TimeSlot> fetchedTimeSlots = [];
  List<TimeSlot> newlyAddedTimeSlots = [];
  Future<void> saveTimeSlots() async {
    if (fetchedTimeSlots.isEmpty && newlyAddedTimeSlots.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please add at least one time slot.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const Center(child: CircularProgressIndicator()),
    );

    try {
      // Combine fetched and newly added slots for saving
      final allSlots = List<TimeSlot>.from(fetchedTimeSlots)
        ..addAll(newlyAddedTimeSlots);

      final merchantNotifier = ref.read(merchantProvider.notifier);
      bool success =
          await merchantNotifier.manageMerchantAvailability(allSlots);

      if (success) {
        Fluttertoast.showToast(
            msg: "Availability updated successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
        // After saving, clear newly added slots and re-fetch slots to sync with Firestore
        newlyAddedTimeSlots.clear();
        fetchTimeSlots();
      } else {
        Fluttertoast.showToast(
            msg: "Failed to update availability.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error occurred: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    // Load merchant's availability slots when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchTimeSlots());
  }

  Future<void> fetchTimeSlots() async {
    // Assuming fetchTimeSlots() is implemented in your merchantNotifier
    final id = ref.read(merchantProvider)?.id;

    final slotsFromFirestore =
        await ref.read(merchantProvider.notifier).loadMerchantTimeSlots(id!);
    if (mounted) {
      setState(() {
        fetchedTimeSlots = slotsFromFirestore;
      });
    }
  }

  void addTimeSlot(TimeSlot slot) {
    setState(() {
      newlyAddedTimeSlots.add(slot);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Combine fetched and newly added time slots, excluding past slots
    final combinedSlots = List<TimeSlot>.from(fetchedTimeSlots)
      ..addAll(newlyAddedTimeSlots)
      ..removeWhere((slot) => slot.end.isBefore(DateTime.now()));

    // Group the combined slots by date
    final groupedSlots = groupTimeSlotsByDate(combinedSlots);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Availability'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed:
                saveTimeSlots, // Assume this function is defined to handle saving logic
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groupedSlots.keys.length,
        itemBuilder: (context, index) {
          final date = groupedSlots.keys.elementAt(index);
          final daySlots = groupedSlots[date]!;
          // Here we use a custom widget TimeSlotCard to display each group of slots
          return TimeSlotCard(
            date: date,
            slots: daySlots,
            onEdit: (slot) {
              // Find the index of the slot being edited
              int index =
                  newlyAddedTimeSlots.indexWhere((s) => s.id == slot.id);
              if (index == -1) {
                // If not found in newlyAddedTimeSlots, check fetchedTimeSlots
                index = fetchedTimeSlots.indexWhere((s) => s.id == slot.id);
                if (index != -1) {
                  // Edit the slot from fetched slots
                  _addOrEditTimeSlot(
                      existingSlot: slot, index: index, isFetched: true);
                }
              } else {
                // Edit the slot from newly added slots
                _addOrEditTimeSlot(existingSlot: slot, index: index);
              }
            },
            //(slot) => _addOrEditTimeSlot(existingSlot: slot),
            onDelete: (slot) async {
              final success = await ref
                  .read(merchantProvider.notifier)
                  .deleteTimeSlot(slot);
              if (success) {
                // Show a success message
                Fluttertoast.showToast(
                  msg: "Time slot deleted successfully.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
                // Update local state
                setState(() {
                  newlyAddedTimeSlots.remove(slot);
                  fetchedTimeSlots.remove(slot);
                });
              } else {
                // Show an error message
                Fluttertoast.showToast(
                  msg: "Failed to delete the time slot.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addOrEditTimeSlot();
        }, // Assume this function is defined to show a dialog for adding/editing slots
        child: const Icon(Icons.add),
      ),
    );
  }
}

// class TimeSlotCard extends StatelessWidget {
//   final String date;
//   final List<TimeSlot> slots;
//   final Function(TimeSlot) onEdit;
//   final Function(TimeSlot) onDelete;

//   const TimeSlotCard(
//       {Key? key,
//       required this.date,
//       required this.slots,
//       required this.onEdit,
//       required this.onDelete})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               DateFormat('EEEE, MMMM d, yyyy').format(DateTime.parse(date)),
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             ...slots.map((slot) {
//               final startTime = DateFormat('HH:mm').format(slot.start);
//               final endTime = DateFormat('HH:mm').format(slot.end);

//               return ListTile(
//                 title: Text("$startTime - $endTime"),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () => onEdit(slot)),
//                     IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => onDelete(slot)),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
class TimeSlotCard extends StatelessWidget {
  final String date;
  final List<TimeSlot> slots;
  final Function(TimeSlot) onEdit;
  final Function(TimeSlot) onDelete;

  const TimeSlotCard({
    Key? key,
    required this.date,
    required this.slots,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(DateTime.parse(date)),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...slots.map((slot) {
              final startTime = DateFormat('HH:mm').format(slot.start);
              final endTime = DateFormat('HH:mm').format(slot.end);

              return ListTile(
                title: Text("$startTime - $endTime"),
                trailing: slot.booked
                    ? Container(
                        decoration: BoxDecoration(
                            color: AppColors.indicator.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            'Booked',
                            style:
                                TextStyle(color: AppColors.bgw, fontSize: 12),
                          ),
                        ),
                      ) // If booked, show a check mark
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => onEdit(slot),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => onDelete(slot),
                          ),
                        ],
                      ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
