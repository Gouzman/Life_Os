import 'package:dun/app/app.dart';
import 'package:dun/core/config/env_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.initialize();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: LifeOsApp()));
}
