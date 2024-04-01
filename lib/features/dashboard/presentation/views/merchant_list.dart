import 'package:appointment_booking_app/core/app/app_colors.dart';
import 'package:appointment_booking_app/features/authentication/presentation/views/login_screen.dart';
import 'package:appointment_booking_app/features/dashboard/presentation/views/merchant_time_slot_screen.dart';
import 'package:appointment_booking_app/features/dashboard/presentation/widgets/merchants_card.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/providers/merchant_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/spacer.dart';
import '../../../merchants/models/merchants.dart';

class MerchantListScreen extends ConsumerWidget {
  const MerchantListScreen({super.key});

  Future<void> _refreshMerchants(WidgetRef ref) async {
    // Call the provider to refresh merchants
    await ref.read(listmerchantProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsyncValue = ref.watch(listmerchantProvider);
    final authValue = ref.read(authStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book an Appointment',
          style: TextStyle(
            color: AppColors.textdark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              // Logout
              await ref.read(authStateProvider.notifier).logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const LoginScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: merchantsAsyncValue.when(
            data: (merchants) {
              return RefreshIndicator(
                onRefresh: () => _refreshMerchants(ref),
                child: Column(
                  children: [
                    // The large container on top
                    Container(
                      width: double.infinity,
                      height: 200, // Adjust the height as needed
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome ${authValue.userModel!.displayName.length > 24 ? '${authValue.userModel!.displayName.substring(0, 21)}...' : authValue.userModel!.displayName}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Height10(),
                          const Text(
                            "Select a merchant to book an appointment",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: merchants.isEmpty
                          ? const Center(
                              child: Text("No merchants available"),
                            )
                          : ListView.separated(
                              itemCount: merchants.length,
                              itemBuilder: (context, index) {
                                Merchant merchant = merchants[index];
                                return MerchantsListCard(
                                  merchant: merchant,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MerchantTimeSlotScreen(
                                                merchant: merchant),
                                      ),
                                    );
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.grey[300]);
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Failed to load merchants: $error'),
            ),
          ),
        ),
      ),
    );
  }
}
