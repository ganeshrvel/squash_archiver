import 'package:dio/dio.dart';

class InternalServerApiError extends DioException {
  final String apiUrl;

  @override
  final String error;

  final String errorMessage;
  final int statusCode;

  final DioException dioError;

  InternalServerApiError({
    required this.apiUrl,
    required this.error,
    required this.errorMessage,
    required this.statusCode,
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}
