import 'package:flutter/material.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/life_score_card.dart';
import '../widgets/pillar_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const DashboardHeader(),

                const SizedBox(height: 24),

                const LifeScoreCard(),

                const SizedBox(height: 24),

                const Text(
                  'Mes piliers',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  crossAxisCount: 2,

                  mainAxisSpacing: 16,

                  crossAxisSpacing: 16,

                  childAspectRatio: 0.95,

                  children: const [
                    PillarCard(
                      title: 'Foi',
                      icon: Icons.self_improvement,
                      progress: 90,
                    ),

                    PillarCard(
                      title: 'Santé',
                      icon: Icons.health_and_safety,
                      progress: 75,
                    ),

                    PillarCard(
                      title: 'Apprentissage',
                      icon: Icons.school,
                      progress: 60,
                    ),

                    PillarCard(
                      title: 'Famille et relations',
                      icon: Icons.family_restroom,
                      progress: 85,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
