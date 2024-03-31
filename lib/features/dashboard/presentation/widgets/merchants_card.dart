import 'package:appointment_booking_app/core/app/app_colors.dart';
import 'package:appointment_booking_app/features/merchants/models/merchants.dart';
import 'package:appointment_booking_app/shared/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MerchantsListCard extends StatefulWidget {
  const MerchantsListCard({
    super.key,
    required this.merchant,
    this.onTap,
  });

  final Merchant merchant;
  final VoidCallback? onTap;

  @override
  State<MerchantsListCard> createState() => _MerchantsListCardState();
}

class _MerchantsListCardState extends State<MerchantsListCard> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final moreInformation = [
      {
        'icon': Icons.account_circle_outlined,
        'label': 'appointments',
        'value': '590',
      },
      {
        'icon': Icons.star_border,
        'label': 'Experience',
        'value': '3 years',
      },
      {
        'icon': Icons.favorite_border,
        'label': 'Rating',
        'value': 4.5,
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10),
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile
            Row(
              children: [
                CircleAvatar(
                    radius: 30.0,
                    backgroundColor: colorScheme.background,
                    backgroundImage:
                        const AssetImage('assets/pngs/user_photo.png')),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.merchant.name,
                            style: textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Text(
                                  'Book Now',
                                  style: TextStyle(
                                      color: AppColors.bgw, fontSize: 12),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        widget.merchant.id,
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onBackground.withOpacity(.5),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: colorScheme.secondary,
                            size: 16,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'New York, USA',
                            style: textTheme.bodySmall!.copyWith(
                              color: colorScheme.onBackground.withOpacity(.5),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Height10(),
            // Divider(height: 32.0, color: colorScheme.surfaceVariant),
            ...[
              Row(
                children: moreInformation
                    .map(
                      (e) => Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              child: Icon(e['icon'] as IconData),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              e['value'].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyLarge!.copyWith(
                                  color: colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e['label'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyLarge!.copyWith(
                                color: colorScheme.primary,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              )
            ]
          ],
        ),
      ),
    );
  }
}
