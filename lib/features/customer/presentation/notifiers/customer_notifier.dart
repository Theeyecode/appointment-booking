// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appointment_booking_app/features/merchants/models/merchants.dart';
import 'package:appointment_booking_app/features/merchants/models/time_slot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appointment_booking_app/features/customer/data/customer_backend.dart';
import 'package:appointment_booking_app/features/customer/models/appointment.dart';
import 'package:uuid/uuid.dart';

import '../../models/customer.dart';

class CustomerNotifier extends StateNotifier<Customer?> {
  final _customerService = CustomerService();

  Ref ref;

  CustomerNotifier(
    this.ref,
  ) : super(null);

  Future<void> fetchOrCreateCustomer(String userId, {String? name}) async {
    try {
      final customer =
          await _customerService.fetchOrCreateCustomer(userId, name: name);
      state = customer;
    } catch (e) {
      print('ERROR OCCURED HERE IN CUSTOMER NOTIFIER');
    }
  }

  Future<bool> bookSlot(Merchant merchant, String timeSlotId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return false;
    }

    final customer = await _customerService.fetchOrCreateCustomer(userId);
    state = customer;
    final TimeSlot? timeSlot = merchant.getTimeSlotById(timeSlotId);
    if (timeSlot == null) {
      print('Time slot not found.');
      return false;
    }

    try {
      // Create an appointment with a new ID
      Appointment newAppointment = Appointment(
        id: const Uuid().v4(), // Or use a UUID
        merchant: merchant,
        merchantId: merchant.id,
        customerId: customer.id,
        customer: customer,
        createdAt: DateTime.now(),
        timeSlot: timeSlot,
      );

      return await _customerService.addAppointmentToCustomer(
          userId, newAppointment);
    } catch (e) {
      return false;
    }
  }
}
