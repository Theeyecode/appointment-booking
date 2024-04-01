import 'package:appointment_booking_app/providers/customer_providers.dart';
import 'package:appointment_booking_app/providers/merchant_providers.dart';
import 'package:flutter/material.dart';
import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';
import 'package:appointment_booking_app/features/merchants/models/merchants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/app/app_colors.dart';

class MerchantTimeSlotScreen extends ConsumerStatefulWidget {
  final Merchant merchant;

  const MerchantTimeSlotScreen({super.key, required this.merchant});

  @override
  MerchantTimeSlotScreenState createState() => MerchantTimeSlotScreenState();
}

class MerchantTimeSlotScreenState
    extends ConsumerState<MerchantTimeSlotScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(merchantProvider.notifier)
            .fetchOrCreateMerchant(widget.merchant.id);
      }
    });
  }

  List<String> selectedSlotIds = []; // To keep track of selected slots

  void _handleSlotSelection(TimeSlot slot) {
    setState(() {
      if (selectedSlotIds.contains(slot.id)) {
        selectedSlotIds.remove(slot.id);
      } else {
        selectedSlotIds.add(slot.id);
      }
    });
  }

  Future<void> _saveSelectedSlots() async {
    // First, mark the selected slots as booked for the merchant.
    final bool slotsMarkedAsBooked = await ref
        .read(merchantProvider.notifier)
        .markSelectedSlotsAsBooked(
            Set.from(selectedSlotIds), widget.merchant.id);

    if (slotsMarkedAsBooked) {
      // If marking slots as booked succeeded, proceed to book slots for the customer.
      bool bookingSuccess = true;
      for (String slotId in selectedSlotIds) {
        final success = await ref
            .read(customerProvider.notifier)
            .bookSlot(widget.merchant.id, slotId);
        if (!success) {
          bookingSuccess = false;
          break; // Exit the loop if any booking fails.
        }
      }

      if (bookingSuccess) {
        setState(() {
          // Clear selected slots after booking successfully
          selectedSlotIds.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Slots booked successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to book some slots.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark slots as booked.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = ref.watch(merchantProvider)?.availableTimeSlots ?? [];
// Ensure time slots are loaded (debugging purpose
    final categorizedSlots = _categorizeTimeSlotsByDate(timeSlots);
    final sortedDates = categorizedSlots.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.merchant.name),
        actions: [
          if (selectedSlotIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveSelectedSlots,
            ),
        ],
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
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: slots.map((slot) {
                    bool isSelected = selectedSlotIds.contains(slot.id);
                    return MerchantTimeSlotWidget(
                      slot: slot,
                      isSelected: isSelected,
                      onSelected: _handleSlotSelection,
                    );
                  }).toList(),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Map<String, List<TimeSlot>> _categorizeTimeSlotsByDate(List<TimeSlot> slots) {
    Map<String, List<TimeSlot>> categorized = {};
    for (var slot in slots) {
      String date = DateFormat('yyyy-MM-dd').format(slot.date);
      categorized.putIfAbsent(date, () => []).add(slot);
    }
    return categorized;
  }
}

class MerchantTimeSlotWidget extends StatefulWidget {
  final TimeSlot slot;
  final bool isSelected;
  final Function(TimeSlot) onSelected;

  const MerchantTimeSlotWidget({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  MerchantTimeSlotWidgetState createState() => MerchantTimeSlotWidgetState();
}

class MerchantTimeSlotWidgetState extends State<MerchantTimeSlotWidget> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.slot.booked
        ? Colors.grey
        : widget.isSelected
            ? Colors.green
            : Colors.deepPurple.withOpacity(0.5);

    return GestureDetector(
      onTap: widget.slot.booked ? null : () => widget.onSelected(widget.slot),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('HH:mm').format(widget.slot.start),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bgw,
                ),
              ),
              Text(
                DateFormat('HH:mm').format(widget.slot.end),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bgw,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
