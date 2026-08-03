import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<bool>((ref) async* {
  // TODO: remplacer par l'ecoute de FirebaseAuth.instance.authStateChanges().
  yield false;
});
