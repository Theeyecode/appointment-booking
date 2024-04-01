import 'package:appointment_booking_app/features/customer/models/appointment.dart';
import 'package:appointment_booking_app/features/dashboard/presentation/widgets/appointments_booking_card.dart';
import 'package:appointment_booking_app/providers/merchant_providers.dart';
import 'package:appointment_booking_app/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookedScreen extends ConsumerStatefulWidget {
  const BookedScreen({super.key});

  @override
  BookedScreenState createState() => BookedScreenState();
}

class BookedScreenState extends ConsumerState<BookedScreen> {
  @override
  void initState() {
    ref.read(merchantServiceProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsStream =
        ref.watch(merchantServiceProvider).fetchAppointmentsByCustomerStream();
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text(
            'Your Appointments',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: StreamBuilder<List<Appointment>>(
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
                  return FutureBuilder<MerchantBookingDetail>(
                    future: ref
                        .read(merchantServiceProvider)
                        .fetchMerchantAndTimeSlotDetails(appointment),
                    builder: (context, detailSnapshot) {
                      if (detailSnapshot.connectionState ==
                          ConnectionState.done) {
                        final details = detailSnapshot.data;
                        final startTime =
                            DateFormat('HH:mm').format(details!.timeSlot.start);
                        final endTime =
                            DateFormat('HH:mm').format(details.timeSlot.end);
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
                                      details.merchantName,
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
        ));
  }
}
