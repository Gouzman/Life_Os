import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_period.dart';

/// Contrôleur de présentation gérant la période sélectionnée du Dashboard.
///
/// Responsabilités :
/// - Maintenir l'état de la période courante (jour, semaine, mois).
/// - Exposer une méthode pour changer de période.
///
/// Ce contrôleur ne dépend d'aucun repository ni use case : il ne fait que
/// gérer un état UI simple.
class DashboardController extends Notifier<DashboardPeriod> {
  @override
  DashboardPeriod build() {
    return DashboardPeriod.day;
  }

  /// Change la période active du Dashboard.
  void setPeriod(DashboardPeriod period) {
    if (state != period) {
      state = period;
    }
  }
}
