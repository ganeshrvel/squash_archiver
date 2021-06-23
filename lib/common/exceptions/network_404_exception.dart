import 'package:squash_archiver/utils/utils/error.dart';

class Network404Exception implements Exception {
  final String errorMessage;
  final String apiUrl;
  final int statusCode;
  final StackTrace stackTrace;

  Network404Exception({
    required this.errorMessage,
    required this.apiUrl,
    required this.statusCode,
    required this.stackTrace,
  });

  @override
  String toString() {
    final _errorBody = getErrorBody({
      'API URL': apiUrl,
      'Status Code': (statusCode).toString(),
      'Error': errorMessage,
    });

    return _errorBody;
  }
}
