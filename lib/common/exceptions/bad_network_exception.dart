import 'package:meta/meta.dart';

class BadNetworkException implements Exception {
  final Exception error;
  final StackTrace stackTrace;

  BadNetworkException({
    @required this.error,
    @required this.stackTrace,
  });

  @override
  String toString() {
    return error.toString();
  }
}
