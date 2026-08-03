import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { dev, staging, prod }

class EnvConfig {
  const EnvConfig._();

  static Future<void> initialize() async {
    const fileName = kReleaseMode
        ? '.env.prod'
        : kProfileMode
        ? '.env.staging'
        : '.env.dev';
    await dotenv.load(fileName: fileName);
  }

  static String get(String key, {String fallback = ''}) {
    return dotenv.get(key, fallback: fallback);
  }

  static Environment get current {
    final env = get('ENV', fallback: 'dev');
    return Environment.values.byName(env);
  }
}
