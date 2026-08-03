import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ConnectivityService {
  Future<bool> get isConnected;
}

class ConnectivityServiceImpl implements ConnectivityService {
  @override
  Future<bool> get isConnected async => true;
}

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityServiceImpl(),
);
