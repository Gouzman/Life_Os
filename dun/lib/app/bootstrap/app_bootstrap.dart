import 'package:dun/app/app.dart';
import 'package:dun/app/providers/repository_providers.dart';
import 'package:dun/core/config/env_config.dart';
import 'package:dun/features/notifications/data/services/flutter_notification_service.dart';
import 'package:dun/features/scheduler/presentation/providers/scheduler_provider.dart';
import 'package:dun/features/sound/data/services/audio_player_sound_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.initialize();
  await Firebase.initializeApp();

  final notificationSvc = FlutterNotificationService();
  await notificationSvc.initialize();

  final soundSvc = AudioPlayerSoundService();
  await soundSvc.initialize();

  runApp(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(notificationSvc),
        soundServiceProvider.overrideWithValue(soundSvc),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          // Eagerly mounts the scheduler so it starts as soon as auth is available.
          ref.read(schedulerControllerProvider);
          return child!;
        },
        child: const LifeOsApp(),
      ),
    ),
  );
}
