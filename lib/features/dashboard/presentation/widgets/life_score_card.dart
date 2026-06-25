import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';

class LifeScoreCard extends StatelessWidget {

  const LifeScoreCard({super.key});

  @override
  Widget build(BuildContext context) {

    return AppCard(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: const [

          Text(
            'Life Score',
            style: TextStyle(fontSize: 18),
          ),

          SizedBox(height: 16),

          Text(
            '84%',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '+5% cette semaine',
          ),
        ],
      ),
    );
  }
}
