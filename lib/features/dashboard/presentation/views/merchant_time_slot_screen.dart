// merchant_time_slot_screen.dart
import 'package:flutter/material.dart';
import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';
import 'package:appointment_booking_app/features/merchants/models/merchants.dart';
import 'package:intl/intl.dart';

import '../../../../core/app/app_colors.dart';
// Ensure this is imported

class MerchantTimeSlotScreen extends StatelessWidget {
  final Merchant merchant;

  const MerchantTimeSlotScreen({super.key, required this.merchant});

  @override
  Widget build(BuildContext context) {
    // Categorize time slots by date
    Map<String, List<TimeSlot>> categorizedSlots = {};
    for (var slot in merchant.availableTimeSlots ?? []) {
      // Extract just the date part in 'yyyy-MM-dd' format
      String date = DateFormat('yyyy-MM-dd').format(slot.date);
      categorizedSlots.putIfAbsent(date, () => []).add(slot);
    }

    // Sort the dates
    var sortedDates = categorizedSlots.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return Scaffold(
      appBar: AppBar(
        title: Text(merchant.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: ListView.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            // Use the sorted date for display
            String date = sortedDates[index];
            List<TimeSlot> slots = categorizedSlots[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(DateTime.parse(date)),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textdark,
                    ),
                  ),
                ),
                Wrap(
                  // Use Wrap here
                  spacing: 8.0, // Add horizontal spacing between children
                  runSpacing: 8.0, // Add vertical spacing between lines
                  children: slots
                      .map((slot) => MerchantTimeSlotWidget(
                            startTime: slot.start,
                            endTime: slot.end,
                          ))
                      .toList(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class MerchantTimeSlotWidget extends StatelessWidget {
  const MerchantTimeSlotWidget({
    super.key,
    required this.startTime,
    required this.endTime,
  });
  final DateTime startTime;
  final DateTime endTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('HH:mm').format(startTime), //start time
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bgw),
              ),
              Text(
                DateFormat('HH:mm').format(endTime),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bgw),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
