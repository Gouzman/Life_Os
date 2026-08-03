import 'package:dun/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Le widget_test complet necessite Firebase initialise.
  // Les tests d'integration seront ajoutes une fois le mock Firebase en place.
  test('LoginScreen type is available', () {
    expect(LoginScreen, isNotNull);
  });
}
