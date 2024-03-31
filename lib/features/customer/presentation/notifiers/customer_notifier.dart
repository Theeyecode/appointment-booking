import 'package:appointment_booking_app/features/customer/data/customer_backend.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/customer.dart';

class CustomerNotifier extends StateNotifier<Customer?> {
  final _customerService = CustomerService();

  CustomerNotifier() : super(null);

  Future<void> fetchOrCreateCustomer(String userId, {String? name}) async {
    try {
      final customer =
          await _customerService.fetchOrCreateCustomer(userId, name: name);
      state = customer;
    } catch (e) {
      print('ERROR OCCURED HERE IN CUSTOMER NOTIFIER');
    }
  }
}
