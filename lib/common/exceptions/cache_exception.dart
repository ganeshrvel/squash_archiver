import 'package:meta/meta.dart';

class CacheException implements Exception {
  final Exception error;
  final StackTrace stackTrace;

  CacheException({
    @required this.error,
    @required this.stackTrace,
  });

  @override
  String toString() {
    return error.toString();
  }
}
