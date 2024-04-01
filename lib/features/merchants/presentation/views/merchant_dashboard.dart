// ignore_for_file: use_build_context_synchronously

import 'package:appointment_booking_app/core/app/app_colors.dart';
import 'package:appointment_booking_app/features/authentication/presentation/views/login_screen.dart';
import 'package:appointment_booking_app/features/customer/models/appointment.dart';
import 'package:appointment_booking_app/features/dashboard/presentation/widgets/appointments_booking_card.dart';
import 'package:appointment_booking_app/features/merchants/presentation/widgets/ext_fab.dart';
import 'package:appointment_booking_app/features/merchants/presentation/widgets/fab.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/providers/merchant_providers.dart';
import 'package:appointment_booking_app/providers/user_id_provider.dart';
import 'package:appointment_booking_app/shared/shimmer.dart';
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
    final appointmentsStream =
        ref.watch(merchantServiceProvider).fetchAppointmentsByMerchantStream();

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
                if (snapshot.connectionState == ConnectionState.active) {
                  final appointments = snapshot.data ?? [];
                  if (appointments.isEmpty) {
                    return const AppointmentPreviewCard();
                  }
                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return FutureBuilder<CustomerBookingDetail>(
                        future: ref
                            .read(merchantServiceProvider)
                            .fetchCustomerAndTimeSlotDetails(appointment),
                        builder: (context, detailSnapshot) {
                          if (detailSnapshot.connectionState ==
                              ConnectionState.done) {
                            final details = detailSnapshot.data;
                            final startTime = DateFormat('HH:mm')
                                .format(details!.timeSlot.start);
                            final endTime = DateFormat('HH:mm')
                                .format(details.timeSlot.end);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                          'assets/pngs/user_photo.png'),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          details.customerName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          DateFormat('EEEE, MMMM d, yyyy')
                                              .format(DateTime.parse(
                                                  '${details.timeSlot.date}')),
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
                          }
                          return const SizedBox(); // Placeholder for loading state
                        },
                      );
                    },
                  );
                }
                return ShimmerLoading();
                // return ShimmerLoading(); // Placeholder for initial loading state
              },
            ),

            // child: asyncAppointments!.when(
            //   data: (appointments) {
            //     if (appointments.isEmpty) {
            //       return Center(
            //         child: Padding(
            //           padding: const EdgeInsets.all(24.0),
            //           child: Image.asset('assets/svgs/no_customer.png'),
            //         ),
            //       );
            //     } else {
            //       return ListView.builder(
            //         physics: const BouncingScrollPhysics(),
            //         controller: _scrollController,
            //         itemCount: appointments.length,
            //         itemBuilder: (context, index) {
            //           final appointment = appointments[index];
            //           final startTime = DateFormat('HH:mm')
            //               .format(appointment.timeSlot.start);
            //           final endTime =
            //               DateFormat('HH:mm').format(appointment.timeSlot.end);
            //           return Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 16.0, vertical: 4),
            //             child: Container(
            //               padding: const EdgeInsets.symmetric(vertical: 8),
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: BorderRadius.circular(16),
            //               ),
            //               child: Row(
            //                 children: [
            //                   ClipRRect(
            //                     borderRadius: BorderRadius.circular(12),
            //                     child:
            //                         Image.asset('assets/pngs/user_photo.png'),
            //                   ),
            //                   const SizedBox(
            //                     width: 12,
            //                   ),
            //                   Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         appointment.customerName,
            //                         style: const TextStyle(
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 16),
            //                       ),
            //                       const SizedBox(
            //                         height: 4,
            //                       ),
            //                       Text(
            //                         DateFormat('EEEE, MMMM d, yyyy').format(
            //                             DateTime.parse(
            //                                 '${appointment.timeSlot.date}')),
            //                         style: const TextStyle(
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.grey,
            //                             fontSize: 14),
            //                       ),
            //                       const SizedBox(
            //                         height: 4,
            //                       ),
            //                       Text(
            //                         "$startTime - $endTime",
            //                         style: const TextStyle(
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.grey,
            //                             fontSize: 14),
            //                       ),
            //                     ],
            //                   )
            //                 ],
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     }
            //   },
            //   loading: () => ShimmerLoading(),
            //   error: (error, stack) => Center(child: Text('Error: $error')),
            // ),
          ),
        ],
      ),
    );
  }
}
