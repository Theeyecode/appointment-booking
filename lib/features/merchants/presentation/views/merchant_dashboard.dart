// ignore_for_file: use_build_context_synchronously

import 'package:appointment_booking_app/core/app/app_colors.dart';
import 'package:appointment_booking_app/features/authentication/presentation/views/login_screen.dart';
import 'package:appointment_booking_app/features/merchants/presentation/views/merchant_availability_screen.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/shared/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchantDashboardScreen extends ConsumerWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 245,
            decoration: const BoxDecoration(
              color: AppColors.textdark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset('assets/pngs/user_photo.png', height: 50),
                      const SizedBox(
                        width: 12,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Howdy',
                            style: TextStyle(
                              color: AppColors.bgw,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Kang Smile',
                            style: TextStyle(
                              color: AppColors.bgw,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset('assets/ic_bell.png', height: 20),
                          ),
                          IconButton(
                            icon: const Icon(Icons.exit_to_app),
                            onPressed: () async {
                              // Logout
                              await ref
                                  .read(authStateProvider.notifier)
                                  .logOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      const LoginScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance',
                            style: TextStyle(
                              color: AppColors.bgw,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '\$12,500,000',
                            style: TextStyle(
                              color: AppColors.bgw,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Number of items in the list
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.asset('assets/svgs/no_customer.png'),
                      const Height10(),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ManageAvailabilityScreen())),
                        child: const Text(
                          'Manage Availability',
                          style: TextStyle(color: AppColors.textdark),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
