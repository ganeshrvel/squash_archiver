import 'package:meta/meta.dart';

class ApiErrorMessageException implements Exception {
  final String errorMessage;
  final StackTrace stackTrace;

  ApiErrorMessageException({
    @required this.errorMessage,
    @required this.stackTrace,
  });

  @override
  String toString() {
    return errorMessage;
  }
}
