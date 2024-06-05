import 'package:logger/logger.dart';

class Log {
  late final Logger _logger;
  Log._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
          methodCount: 2, // number of method calls to be displayed
          errorMethodCount:
              8, // number of method calls if stacktrace is provided
          lineLength: 120, // width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ),
    );
  }

  static final Log _singleton = Log._internal();

  static void verbose(dynamic message) => _singleton._logger.t(message);

  static void debug(dynamic message) => _singleton._logger.d(message);

  static void info(dynamic message) => _singleton._logger.i(message);

  static void error(dynamic message) => _singleton._logger.e(message);

  static void errorStackTrace(
          dynamic message, dynamic error, StackTrace? stackTrace) =>
      _singleton._logger.e(message,
          time: DateTime.now(), error: error, stackTrace: stackTrace);

  static void warning(dynamic message) => _singleton._logger.w(message);
}
