import 'package:equatable/equatable.dart';

/// Payload immutable décrivant une notification à afficher ou planifier.
///
/// Cette entité du domaine ne contient aucune logique métier. Elle est
/// utilisée comme contrat d'entrée pour [NotificationService].
class NotificationPayload extends Equatable {
  const NotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    this.route,
    this.data = const {},
  });

  /// Identifiant unique de la notification.
  final String id;

  /// Titre affiché dans l'en-tête de la notification.
  final String title;

  /// Corps du message de la notification.
  final String body;

  /// Route de l'application à ouvrir lorsque l'utilisateur interagit avec la
  /// notification.
  final String? route;

  /// Données additionnelles associées à la notification.
  final Map<String, String> data;

  /// Retourne une copie du payload avec les valeurs fournies remplacées.
  NotificationPayload copyWith({
    String? id,
    String? title,
    String? body,
    String? route,
    Map<String, String>? data,
  }) {
    return NotificationPayload(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      route: route ?? this.route,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [id, title, body, route, data];
}
