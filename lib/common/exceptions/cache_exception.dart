import 'package:squash_archiver/utils/utils/error.dart';


class CacheException implements Exception {
  final Exception error;
  final StackTrace stackTrace;

  CacheException({
    required this.error,
    required this.stackTrace,
  });

  @override
  String toString() {
    final _errorBody = getErrorBody({
      'Error': error.toString(),
    });

    return _errorBody;
  }
}
