import 'package:logger/logger.dart';
import 'package:pretty_json/pretty_json.dart';

/* Log service to allow meaningful console log messages */

class LogService {
  infoObj(Map<String, dynamic> data, [int stackCall = 0]) {
    final logger = Logger(
      printer: PrettyPrinter(
          methodCount: stackCall,
          colors: true,
          printTime: true,
          printEmojis: false),
    );
    logger.d(prettyJson(data));
  }

  infoString(String data, [int stackCall = 0]) {
    final logger = Logger(
      printer: PrettyPrinter(
          methodCount: stackCall,
          colors: true,
          printTime: true,
          printEmojis: false),
    );
    logger.d(data);
  }

  successObj(Map<String, dynamic> data, [int stackCall = 0]) {
    final logger = Logger(
      printer: PrettyPrinter(
          methodCount: stackCall,
          colors: true,
          printTime: true,
          printEmojis: false),
    );
    logger.i(prettyJson(data));
  }

  successString(String data, [int stackCall = 0]) {
    final logger = Logger(
      printer: PrettyPrinter(
          methodCount: stackCall,
          colors: true,
          printTime: true,
          printEmojis: false),
    );
    logger.i(data);
  }

  errorObj(Map<String, dynamic> data, [int stackCall = 0]) {
    final logger = Logger(
      printer: PrettyPrinter(
          methodCount: stackCall,
          colors: true,
          printTime: true,
          printEmojis: false),
    );
    logger.e(prettyJson(data));
  }

  errorString(String data, [int stackCall = 0]) {
    final logger = Logger(
      printer: PrettyPrinter(
          methodCount: stackCall,
          colors: true,
          printTime: true,
          printEmojis: false),
    );
    logger.e(data);
  }
}
