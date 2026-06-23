import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';

class AppCard extends StatelessWidget {

  final Widget child;

  const AppCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: AppColors.card,

        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ),
      ),

      child: child,
    );
  }
}
