import 'package:squash_archiver/utils/utils/error.dart';

class DioClientException implements Exception {
  final Exception error;
  final String apiUrl;
  final StackTrace stackTrace;
  final int statusCode;

  DioClientException({
    required this.error,
    required this.apiUrl,
    required this.stackTrace,
    required this.statusCode,
  });

  @override
  String toString() {
    final _errorBody = getErrorBody({
      'API URL': apiUrl,
      'Status Code': (statusCode).toString(),
      'Error': error.toString(),
    });

    return _errorBody;
  }
}
