import 'package:meta/meta.dart';
import 'package:squash_archiver/utils/utils/error.dart';

class BadNetworkException implements Exception {
  final Exception error;
  final StackTrace stackTrace;
  final int statusCode;
  final String apiUrl;

  BadNetworkException({
    @required this.error,
    @required this.statusCode,
    @required this.stackTrace,
    @required this.apiUrl,
  });

  @override
  String toString() {
    final _errorBody = getErrorBody({
      'API URL': apiUrl,
      'Status Code': (statusCode ?? '').toString(),
      'Error': error.toString(),
    });

    return _errorBody;
  }
}
