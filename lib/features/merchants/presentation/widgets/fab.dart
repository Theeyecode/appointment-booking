import 'package:appointment_booking_app/features/merchants/presentation/views/merchant_availability_screen.dart';
import 'package:flutter/material.dart';

Widget buildFAB(BuildContext context) => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 50,
      height: 50,
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ManageAvailabilityScreen())),
        icon: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.edit),
        ),
        label: const SizedBox(),
      ),
    );
