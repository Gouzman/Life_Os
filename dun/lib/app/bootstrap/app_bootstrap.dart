import 'package:dun/app/app.dart';
import 'package:dun/app/providers/repository_providers.dart';
import 'package:dun/core/config/env_config.dart';
import 'package:dun/features/notifications/data/services/flutter_notification_service.dart';
import 'package:dun/features/scheduler/application/handlers/scheduler_task_due_listener_provider.dart';
import 'package:dun/features/scheduler/presentation/providers/scheduler_provider.dart';
import 'package:dun/features/sound/data/services/audio_player_sound_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.initialize();

  await Supabase.initialize(
    url: EnvConfig.get('SUPABASE_URL'),
    publishableKey: EnvConfig.get('SUPABASE_PUBLISHABLE_KEY'),
  );

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
          ref.read(schedulerControllerProvider);
          ref.read(schedulerTaskDueListenerProvider);

          return child!;
        },
        child: const LifeOsApp(),
      ),
    ),
  );
}
