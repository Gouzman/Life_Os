import 'package:equatable/equatable.dart';

/// Métrique journalière orientée visualisation.
///
/// Utilisée par les graphiques du Dashboard pour afficher la répartition des
/// tâches sur une journée donnée.
class DailyMetric extends Equatable {
  const DailyMetric({
    required this.day,
    required this.shortLabel,
    required this.fullLabel,
    required this.total,
    required this.completed,
  });

  /// Date de la journée.
  final DateTime day;

  /// Libellé court affichable sur l'axe (ex: Lun, Mar).
  final String shortLabel;

  /// Libellé complet affichable dans les tooltips (ex: Lundi 4 août).
  final String fullLabel;

  /// Nombre total de tâches pour cette journée.
  final int total;

  /// Nombre de tâches terminées pour cette journée.
  final int completed;

  /// Nombre de tâches non terminées pour cette journée.
  int get remaining => total - completed;

  @override
  List<Object?> get props => [day, shortLabel, fullLabel, total, completed];
}
