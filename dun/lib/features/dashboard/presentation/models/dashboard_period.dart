/// Période de temps utilisée pour agréger les métriques du Dashboard.
enum DashboardPeriod {
  /// Vue centrée sur la journée courante.
  day,

  /// Vue centrée sur la semaine courante (lundi → dimanche).
  week,

  /// Vue centrée sur le mois courant.
  month;

  /// Libellé court affichable dans l'UI.
  String get label {
    return switch (this) {
      day => 'Jour',
      week => 'Semaine',
      month => 'Mois',
    };
  }
}
