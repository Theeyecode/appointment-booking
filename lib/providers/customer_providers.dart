import 'package:appointment_booking_app/features/customer/data/customer_backend.dart';
import 'package:appointment_booking_app/features/customer/presentation/notifiers/customer_notifier.dart';
// ignore: unused_import
import 'package:appointment_booking_app/providers/user_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/customer/models/customer.dart';

final customerProvider = StateNotifierProvider<CustomerNotifier, Customer?>(
  (ref) => CustomerNotifier(ref),
);

final customerServiceProvider = Provider<CustomerService>((ref) {
  return CustomerService();
});
