import 'package:appointment_booking_app/core/app/app_icon.dart';
import 'package:flutter/material.dart';

class CustomLeading extends StatelessWidget {
  const CustomLeading({super.key, this.disable = false});
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (disable) {
          return;
        }
        // PeakRouter.goBack(context);
      },
      icon: Icon(
        AppIcons.backButton,
        size: 24,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
