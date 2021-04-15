import 'package:dio/dio.dart';

class UnauthorizedApiError extends DioError {
  final String apiUrl;
  final int statusCode;

  final DioError dioError;

  UnauthorizedApiError({
    required this.apiUrl,
    required this.statusCode,
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}
