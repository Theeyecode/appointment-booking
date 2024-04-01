// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Future<bool> bookSlot(String merchantId, String timeSlotId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return false;
    }

    final customer = await _customerService.fetchOrCreateCustomer(userId);
    state = customer; // Update state with the fetched or created customer

    try {
      // Create an appointment with a new ID
      Appointment newAppointment = Appointment(
        id: const Uuid().v4(), // Or use a UUID
        merchantId: merchantId,
        customerId: userId,
        timeSlotId: timeSlotId,
      );

      return await _customerService.addAppointmentToCustomer(
          userId, newAppointment);
    } catch (e) {
      return false;
    }
  }
}
