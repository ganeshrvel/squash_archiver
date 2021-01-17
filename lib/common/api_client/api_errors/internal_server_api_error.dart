import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class InternalServerApiError extends DioError {
  final String apiUrl;

  @override
  final String error;

  final String errorMessage;
  final int statusCode;

  InternalServerApiError({
    @required this.apiUrl,
    @required this.error,
    @required this.errorMessage,
    @required this.statusCode,
  });
}
