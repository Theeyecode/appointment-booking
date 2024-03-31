import 'package:appointment_booking_app/shared/spacer.dart';
import 'package:flutter/material.dart';

import '../core/app/app_colors.dart';

class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({
    super.key,
    required this.title,
    required this.description,
  });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: 32,
                color: AppColors.textdark,
                fontWeight: FontWeight.w500,
              ),
        ),
        const Height10(),
        Text(
          description,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.textdark,
                fontWeight: FontWeight.w300,
              ),
        )
      ],
    );
  }
}
