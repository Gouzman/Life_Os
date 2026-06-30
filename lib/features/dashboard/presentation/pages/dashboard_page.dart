import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_section_title.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/hero_mission_card.dart';
import '../widgets/life_score_card.dart';
import '../widgets/pillar_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const _domains = [
    _DomainProgress('Sante', Icons.favorite_outline, 78, AppColors.success),
    _DomainProgress('Business', Icons.trending_up, 64, AppColors.accent),
    _DomainProgress(
      'Apprentissage',
      Icons.school_outlined,
      52,
      AppColors.warning,
    ),
    _DomainProgress('Relations', Icons.groups_outlined, 71, AppColors.primary),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth >= 1040
                ? 1040.0
                : double.infinity;
            final isWide = constraints.maxWidth >= 760;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DashboardHeader(),
                      const Gap(AppSpacing.xl),
                      if (isWide)
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: HeroMissionCard()),
                            Gap(AppSpacing.lg),
                            Expanded(child: LifeScoreCard()),
                          ],
                        )
                      else
                        const Column(
                          children: [
                            HeroMissionCard(),
                            Gap(AppSpacing.lg),
                            LifeScoreCard(),
                          ],
                        ),
                      const Gap(AppSpacing.xl),
                      const AppSectionTitle(title: 'Domaines de vie'),
                      const Gap(AppSpacing.md),
                      _DomainGrid(domains: _domains),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DomainGrid extends StatelessWidget {
  final List<_DomainProgress> domains;

  const _DomainGrid({required this.domains});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 900
            ? 4
            : width >= 620
            ? 3
            : 2;

        return GridView.builder(
          itemCount: domains.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final domain = domains[index];
            return PillarCard(
              title: domain.title,
              icon: domain.icon,
              progress: domain.progress,
              color: domain.color,
            );
          },
        );
      },
    );
  }
}

class _DomainProgress {
  final String title;
  final IconData icon;
  final int progress;
  final Color color;

  const _DomainProgress(this.title, this.icon, this.progress, this.color);
}
