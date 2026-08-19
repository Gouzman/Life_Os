import 'package:dun/core/config/env_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppSupabase {
  const AppSupabase._();

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    final url = EnvConfig.supabaseUrl;
    final publishableKey = EnvConfig.supabasePublishableKey;

    if (url.isEmpty) {
      throw StateError('SUPABASE_URL is not configured.');
    }

    if (publishableKey.isEmpty) {
      throw StateError('SUPABASE_PUBLISHABLE_KEY is not configured.');
    }

    await Supabase.initialize(url: url, publishableKey: publishableKey);
  }
}
