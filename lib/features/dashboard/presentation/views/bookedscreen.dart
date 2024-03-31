import 'package:appointment_booking_app/features/dashboard/presentation/widgets/appointments_booking_card.dart';
import 'package:flutter/material.dart';

class BookedScreen extends StatelessWidget {
  const BookedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booked Appointments',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // Adjust the color as needed
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Center(
              child: AppointmentPreviewCard(),
            ),
          ],
        ),
      ),
    );
  }
}
