import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../app/theme/app_colors.dart';

class PillarCard extends StatelessWidget {

  final String title;

  final IconData icon;

  final int progress;

  const PillarCard({
    super.key,
    required this.title,
    required this.icon,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {

    return AppCard(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Icon(
            icon,
            size: 28,
            color: AppColors.primary,
          ),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            '%',
          ),
        ],
      ),
    );
  }
}
