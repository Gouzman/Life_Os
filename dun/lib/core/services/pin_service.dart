import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class PinService {
  Future<bool> get hasPin;

  Future<String?> getPin();

  Future<void> setPin(String pin);

  Future<void> clearPin();

  Future<bool> validatePin(String pin);
}

class SecurePinService implements PinService {
  const SecurePinService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _pinKey = 'app_pin';
  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> get hasPin async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }

  @override
  Future<String?> getPin() async {
    try {
      return await _secureStorage.read(key: _pinKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setPin(String pin) async {
    await _secureStorage.write(key: _pinKey, value: pin);
  }

  @override
  Future<void> clearPin() async {
    await _secureStorage.delete(key: _pinKey);
  }

  @override
  Future<bool> validatePin(String pin) async {
    final storedPin = await getPin();
    return storedPin == pin;
  }
}
