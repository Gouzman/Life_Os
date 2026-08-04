import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/dashboard_controller.dart';
import '../models/dashboard_period.dart';

/// Fournit la période active du Dashboard.
///
/// Utilisé par les widgets et les providers dérivés (métriques) pour savoir
/// quelle fenêtre temporelle afficher.
final dashboardControllerProvider =
    NotifierProvider<DashboardController, DashboardPeriod>(
      DashboardController.new,
    );
