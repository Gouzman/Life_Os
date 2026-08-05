import '../entities/notification_payload.dart';

/// Contrat abstrait du service de notifications.
///
/// Ce contrat est placé dans la couche domaine afin que les features
/// (Scheduler, Focus Mode, Dashboard, History, Analytics) ne dépendent
/// jamais d'une implémentation concrète ni de FlutterLocalNotificationsPlugin.
abstract class NotificationService {
  /// Initialise le service de notifications.
  ///
  /// Doit être appelé une fois au démarrage de l'application.
  Future<void> initialize();

  /// Affiche immédiatement une notification.
  Future<void> show(NotificationPayload payload);

  /// Planifie une notification à l'horodatage [scheduledAt].
  Future<void> schedule(NotificationPayload payload, DateTime scheduledAt);

  /// Annule la notification identifiée par [id].
  Future<void> cancel(String id);

  /// Annule toutes les notifications planifiées et affichées.
  Future<void> cancelAll();
}
