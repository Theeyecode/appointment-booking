import 'package:appointment_booking_app/features/merchants/data/merchant_backend.dart';
import 'package:appointment_booking_app/features/merchants/models/merchants.dart';
import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// Adjust path as necessary

class MerchantNotifier extends StateNotifier<Merchant?> {
  final _merchantService = MerchantService();

  MerchantNotifier() : super(null);

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

  Future<List<TimeSlot>> loadMerchantTimeSlots() async {
    final merchantId = state?.id;
    if (merchantId != null) {
      List<TimeSlot> slots =
          await _merchantService.fetchMerchantTimeSlots(merchantId);
      state = state?.copyWith(availableTimeSlots: slots);
      return slots;
    }
    return [];
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
}
