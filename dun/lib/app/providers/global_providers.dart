import 'package:dun/config/constants/app_constants.dart';
import 'package:dun/core/services/pin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final nowProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final appDateFormatProvider = Provider<DateFormat>(
  (ref) => DateFormat(AppConstants.defaultDatePattern),
);

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final pinServiceProvider = Provider<PinService>(
  (ref) => const SecurePinService(),
);
