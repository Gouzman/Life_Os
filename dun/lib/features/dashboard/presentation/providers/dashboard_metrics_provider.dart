import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/dashboard_metrics_controller.dart';
import '../models/dashboard_metrics.dart';

/// Fournit les métriques du Dashboard pour la période active et l'utilisateur
/// courant.
///
/// Ce provider est purement de présentation : il consomme le flux de tâches
/// existant ([tasksStreamProvider]) et recalcule les métriques à chaque
/// changement de période ou de données.
final dashboardMetricsProvider =
    NotifierProvider<DashboardMetricsController, DashboardMetrics>(
      DashboardMetricsController.new,
    );
