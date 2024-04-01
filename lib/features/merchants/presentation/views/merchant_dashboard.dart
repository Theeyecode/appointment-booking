// ignore_for_file: use_build_context_synchronously

import 'package:appointment_booking_app/core/app/app_colors.dart';
import 'package:appointment_booking_app/features/authentication/presentation/views/login_screen.dart';
import 'package:appointment_booking_app/features/customer/models/appointment.dart';
import 'package:appointment_booking_app/features/dashboard/presentation/widgets/appointments_booking_card.dart';
import 'package:appointment_booking_app/features/merchants/presentation/widgets/ext_fab.dart';
import 'package:appointment_booking_app/features/merchants/presentation/widgets/fab.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/providers/merchant_providers.dart';
import 'package:appointment_booking_app/shared/shimmer.dart';
import 'package:appointment_booking_app/shared/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MerchantDashboardScreen extends ConsumerStatefulWidget {
  const MerchantDashboardScreen({super.key});
  @override
  MerchantDashboardScreenState createState() => MerchantDashboardScreenState();
}

class MerchantDashboardScreenState
    extends ConsumerState<MerchantDashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isFAB = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() {
          isFAB = true;
        });
      } else {
        setState(() {
          isFAB = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final merchant = ref.watch(authStateProvider.notifier);

    // final asyncAppointments = idToUse != null
    //     ? ref.watch(appointmentsByMerchantProvider(idToUse))
    //     : null;
    final appointmentsStream = ref
        .watch(merchantServiceProvider)
        .fetchMerchantAppointmentsStream(merchant.userModel!.id);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton:
          isFAB ? buildFAB(context) : buildExtendedFAB(context),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello,',
                            style: TextStyle(
                              color: AppColors.bgw,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            merchant.userModel!.displayName.length > 24
                                ? '${merchant.userModel!.displayName.substring(0, 21)}...'
                                : merchant.userModel!.displayName,
                            style: const TextStyle(
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
                            onPressed: () async {},
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
            child: StreamBuilder<List<Appointment>>(
              stream: appointmentsStream,
              builder: (context, snapshot) {
                // First, handle the case where there is an error.
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Text('Error: ${snapshot.error}');
                }

                // Next, handle the loading state.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerLoading(); // Show a shimmer loading indicator while waiting for data
                }

                // If the snapshot has data, then display the appointments.
                if (snapshot.hasData) {
                  // Sort appointments by their timeSlot start time
                  var appointments = snapshot.data!;
                  if (appointments.isEmpty) {
                    // If there are no appointments, show the AppointmentPreviewCard.
                    return const AppointmentPreviewCard();
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      final startTime = DateFormat('HH:mm')
                          .format(appointment.timeSlot.start);
                      final endTime =
                          DateFormat('HH:mm').format(appointment.timeSlot.end);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    Image.asset('assets/pngs/user_photo.png'),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.customer.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    DateFormat('EEEE, MMMM d, yyyy').format(
                                        DateTime.parse(
                                            '${appointment.timeSlot.date}')),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "$startTime - $endTime",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return ShimmerLoading();
              },
            ),
          ),
        ],
      ),
    );
  }
}
