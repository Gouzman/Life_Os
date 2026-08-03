import 'dart:developer' as developer;

abstract class AppLogger {
  void debug(String message);
  void info(String message);
  void warning(String message);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

class DevAppLogger implements AppLogger {
  const DevAppLogger();

  void _log(String level, String message) {
    developer.log('[$level] $message');
  }

  @override
  void debug(String message) => _log('DEBUG', message);

  @override
  void info(String message) => _log('INFO', message);

  @override
  void warning(String message) => _log('WARN', message);

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log('ERROR', '$message${error != null ? ' | $error' : ''}');
    if (stackTrace != null) developer.log(stackTrace.toString());
  }
}
