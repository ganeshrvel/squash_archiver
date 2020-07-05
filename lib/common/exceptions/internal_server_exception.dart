import 'package:meta/meta.dart';

class InternalServerException implements Exception {
  final Exception error;
  final StackTrace stackTrace;

  InternalServerException({
    @required this.error,
    @required this.stackTrace,
  });

  @override
  String toString() {
    return error.toString();
  }
}
