import 'package:dun/app/providers/global_providers.dart';
import 'package:dun/core/network/connectivity_service.dart';
import 'package:dun/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dun/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:dun/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dun/features/auth/domain/repositories/auth_repository.dart';
import 'package:dun/features/history/data/datasources/history_remote_datasource.dart';
import 'package:dun/features/history/data/repositories/history_repository_impl.dart';
import 'package:dun/features/history/domain/repositories/history_repository.dart';
import 'package:dun/features/notifications/data/services/flutter_notification_service.dart';
import 'package:dun/features/notifications/domain/services/notification_service.dart';
import 'package:dun/features/sound/data/services/audio_player_sound_service.dart';
import 'package:dun/features/sound/domain/services/sound_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return SupabaseAuthDataSource(
    client: ref.read(supabaseClientProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    connectivityService: ref.read(connectivityServiceProvider),
  );
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return FlutterNotificationService();
});

final soundServiceProvider = Provider<SoundService>((ref) {
  return AudioPlayerSoundService();
});

final historyRemoteDatasourceProvider = Provider<HistoryRemoteDatasource>((ref) {
  throw UnimplementedError(
    'History Supabase datasource has not been migrated yet.',
  );
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(
    ref.read(historyRemoteDatasourceProvider),
  );
});
