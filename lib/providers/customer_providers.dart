import 'package:appointment_booking_app/features/customer/presentation/notifiers/customer_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/customer/models/customer.dart';

final customerProvider = StateNotifierProvider<CustomerNotifier, Customer?>(
  (ref) => CustomerNotifier(),
);
