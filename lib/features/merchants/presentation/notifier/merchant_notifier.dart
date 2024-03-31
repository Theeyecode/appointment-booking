import 'package:appointment_booking_app/features/merchants/data/merchant_backend.dart';
import 'package:appointment_booking_app/features/merchants/models/merchants.dart';
import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// Adjust path as necessary

class MerchantNotifier extends StateNotifier<Merchant?> {
  final _merchantService = MerchantService();

  MerchantNotifier() : super(null);

  List<TimeSlot>? _timeSlots;
  List<TimeSlot>? get timeSlots => _timeSlots;

  // Fetch or create merchant
  Future<void> fetchOrCreateMerchant(String userId, {String? name}) async {
    try {
      final merchant =
          await _merchantService.fetchOrCreateMerchant(userId, name: name);
      state = merchant;
    } catch (e) {
      print('EROOR OCCURED HERE IN MERCHANT NOTIFIER');
    }
  }

  // Update merchant availability
  Future<bool> manageMerchantAvailability(List<TimeSlot> slots) async {
    final merchantId = state?.id; // Get the current merchant ID from state
    if (merchantId != null) {
      final success =
          await _merchantService.updateMerchantAvailability(merchantId, slots);

      if (success) {
        state = state?.copyWith(availableTimeSlots: slots);
        return true;
        // Optionally, you can show a success message or perform other actions here.
      } else {
        return false;
        // Optionally, you can show an error message or perform other actions here.
      }
    } else {
      print('merchant id is null');
      // Handle the case when merchant ID is not available.
      // Optionally, you can show an error message or perform other actions here.
    }
    return false;
  }

  Future<List<TimeSlot>> loadMerchantTimeSlots(String id,
      {String? merchantId}) async {
    print('Got to loadMerchantTimeSlots: $id');

    List<TimeSlot> slots = await _merchantService.fetchMerchantTimeSlots(id);
    // If merchantId was not provided, update the state.
    if (merchantId == null) {
      state = state?.copyWith(availableTimeSlots: slots);
    }
    _timeSlots = slots;
    print('Got to loadMerchantTimeSlots: ${_timeSlots!.length}');
    return slots;
  }

  Future<bool> deleteTimeSlot(TimeSlot slot) async {
    if (state?.id == null) return false;

    final result = await _merchantService.deleteTimeSlot(state!.id, slot);
    if (result) {
      // Remove the slot from the local state as well
      state = state!.copyWith(
        availableTimeSlots:
            state!.availableTimeSlots?.where((s) => s != slot).toList(),
      );
      return true;
    }
    return false;
  }

  Future<bool> markSelectedSlotsAsBooked(
      Set<String> slotIds, String? merchantId) async {
    if (merchantId == null) {
      print("No merchant ID found.");
      return false;
    }
    try {
      final success =
          await _merchantService.markSlotsAsBooked(merchantId, slotIds);
      if (success) {
        // Optionally refresh the merchant's time slots from the database
        await loadMerchantTimeSlots(state!.id);
        return true;
      }
      return false;
    } catch (e) {
      print("Error marking slots as booked: $e");
      return false;
    }
  }
}
