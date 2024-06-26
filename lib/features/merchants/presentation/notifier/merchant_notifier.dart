// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appointment_booking_app/features/customer/models/appointment.dart';
import 'package:appointment_booking_app/features/merchants/data/merchant_backend.dart';
import 'package:appointment_booking_app/features/merchants/models/merchants.dart';
import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';


class MerchantNotifier extends StateNotifier<Merchant?> {
  final _merchantService = MerchantService();

  Ref ref;

  MerchantNotifier(
    this.ref,
  ) : super(null);

  List<Appointment>? _appointments;
  List<Appointment>? get appointments => _appointments;

  // Fetch or create merchant
  Future<void> fetchOrCreateMerchant(String userId, {String? name}) async {
    clearTimeSlots();
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
      } else {
        return false;
      }
    } else {}
    return false;
  }

  Future<List<TimeSlot>> loadMerchantTimeSlots(String id,
      {String? merchantId}) async {
    List<TimeSlot> slots = await _merchantService.fetchMerchantTimeSlots(id);

    if (merchantId == null) {
      state = state?.copyWith(availableTimeSlots: slots);
    }

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
      return false;
    }
  }

  void clearTimeSlots() {
    state = state?.copyWith(availableTimeSlots: []);
  }
}
