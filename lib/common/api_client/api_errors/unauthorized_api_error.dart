import 'package:dio/dio.dart';

class UnauthorizedApiError extends DioException {
  final String apiUrl;
  final int statusCode;

  final DioException dioError;

  UnauthorizedApiError({
    required this.apiUrl,
    required this.statusCode,
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}
