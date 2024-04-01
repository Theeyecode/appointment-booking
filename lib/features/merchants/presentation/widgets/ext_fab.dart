import 'package:appointment_booking_app/core/app/app_colors.dart';
import 'package:appointment_booking_app/features/merchants/presentation/views/merchant_availability_screen.dart';
import 'package:flutter/material.dart';

Widget buildExtendedFAB(BuildContext context) => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 150,
      height: 40,
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ManageAvailabilityScreen())),
        icon: const Icon(Icons.add),
        label: const Center(
          child: Text(
            "Availability",
            style: TextStyle(color: AppColors.textdark),
          ),
        ),
      ),
    );
