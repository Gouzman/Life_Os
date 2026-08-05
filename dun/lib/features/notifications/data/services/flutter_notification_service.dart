import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/notification_payload.dart';
import '../../domain/services/notification_service.dart';

/// Implémentation concrète de [NotificationService] basée sur
/// flutter_local_notifications.
///
/// Cette classe se trouve dans la couche data. Elle ne contient aucune logique
/// métier et ne dépend d'aucune feature de l'application.
class FlutterNotificationService implements NotificationService {
  FlutterNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _androidChannelId = 'life_os_channel';
  static const _androidChannelName = 'Life OS';
  static const _androidChannelDescription = 'Notifications de Life OS';

  @override
  Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings();
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Ouvrir',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
    );

    await _plugin.initialize(settings: initializationSettings);
  }

  @override
  Future<void> show(NotificationPayload payload) async {
    final notificationDetails = _buildNotificationDetails(payload);

    await _plugin.show(
      id: payload.id.hashCode,
      title: payload.title,
      body: payload.body,
      notificationDetails: notificationDetails,
      payload: _encodePayload(payload),
    );
  }

  @override
  Future<void> schedule(
    NotificationPayload payload,
    DateTime scheduledAt,
  ) async {
    final notificationDetails = _buildNotificationDetails(payload);
    final tzScheduledAt = tz.TZDateTime.from(scheduledAt, tz.local);

    await _plugin.zonedSchedule(
      id: payload.id.hashCode,
      scheduledDate: tzScheduledAt,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: payload.title,
      body: payload.body,
      payload: _encodePayload(payload),
    );
  }

  @override
  Future<void> cancel(String id) async {
    await _plugin.cancel(id: id.hashCode);
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  NotificationDetails _buildNotificationDetails(NotificationPayload payload) {
    final androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ticker: payload.title,
    );

    const darwinDetails = DarwinNotificationDetails();
    const linuxDetails = LinuxNotificationDetails();

    return NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
      linux: linuxDetails,
    );
  }

  String? _encodePayload(NotificationPayload payload) {
    final buffer = StringBuffer()
      ..writeln('id=${payload.id}')
      ..writeln('title=${payload.title}')
      ..writeln('body=${payload.body}');

    if (payload.route != null) {
      buffer.writeln('route=${payload.route}');
    }

    if (payload.data.isNotEmpty) {
      buffer.writeln(
        'data=${payload.data.entries.map((e) => '${e.key}=${e.value}').join('&')}',
      );
    }

    return buffer.toString();
  }
}
