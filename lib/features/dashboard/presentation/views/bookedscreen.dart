import 'package:appointment_booking_app/features/customer/models/appointment.dart';
import 'package:appointment_booking_app/features/dashboard/presentation/widgets/appointments_booking_card.dart';
import 'package:appointment_booking_app/providers/auth_providers.dart';
import 'package:appointment_booking_app/providers/customer_providers.dart';
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
    ref.read(customerServiceProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customer = ref.watch(authStateProvider.notifier);
    final appointmentsStream = ref
        .watch(customerServiceProvider)
        .fetchCustomerAppointmentsStream(customer.userModel!.id);
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
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final startTime =
                    DateFormat('HH:mm').format(appointment.timeSlot.start);
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
                          child: Image.asset('assets/pngs/user_photo.png'),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.merchant.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }
}
