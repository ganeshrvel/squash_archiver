import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class LoggerDi {
  @lazySingleton
  Logger get logger => Logger(
        filter: null,
        printer: PrettyPrinter(
          methodCount: 10,
          // number of method calls to be displayed
          errorMethodCount: 8,
          // width of the output
          colors: true,
          // Colorful log messages
          printEmojis: true,
          // Print an emoji for each log message
          printTime: true, // Should each log print contain a timestamp
        ),
        output: null,
      );
}
