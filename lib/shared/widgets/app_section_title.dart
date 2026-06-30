import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const AppSectionTitle({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
