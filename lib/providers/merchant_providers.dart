import 'package:appointment_booking_app/features/merchants/data/merchant_backend.dart';
import 'package:appointment_booking_app/features/merchants/presentation/notifier/merchant_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/merchants/models/merchants.dart';

final merchantProvider =
    StateNotifierProvider<MerchantNotifier, Merchant?>((ref) {
  return MerchantNotifier(ref);
});

final listmerchantStreamProvider = StreamProvider<List<Merchant>>((ref) {
  final merchantService = ref.watch(merchantServiceProvider);
  return merchantService.fetchMerchants();
});

final merchantServiceProvider = Provider<MerchantService>((ref) {
  return MerchantService();
});
