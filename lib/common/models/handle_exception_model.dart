import 'package:meta/meta.dart';

class HandleExceptionModel {
  final StackTrace stackTrace;
  final String body;
  final Exception exception;

  HandleExceptionModel({
    @required this.stackTrace,
    @required this.body,
    @required this.exception,
  });
}
