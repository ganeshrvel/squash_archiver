import 'package:squash_archiver/utils/utils/error.dart';

class InternalServerException implements Exception {
  final Exception error;
  final String errorMessage;
  final String apiUrl;
  final int statusCode;
  final StackTrace stackTrace;

  InternalServerException({
    required this.error,
    required this.errorMessage,
    required this.statusCode,
    required this.apiUrl,
    required this.stackTrace,
  });

  @override
  String toString() {
    final _errorBody = getErrorBody({
      'API URL': apiUrl,
      'Error': error.toString(),
      'Status Code': (statusCode).toString(),
      'Error Message': errorMessage,
    });

    return _errorBody;
  }
}
