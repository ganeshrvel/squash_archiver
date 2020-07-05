import 'package:meta/meta.dart';

class DioException implements Exception {
  final Exception error;
  final StackTrace stackTrace;

  DioException({
    @required this.error,
    @required this.stackTrace,
  });

  @override
  String toString() {
    return error.toString();
  }
}
