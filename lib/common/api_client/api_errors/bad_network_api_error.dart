import 'package:dio/dio.dart';

class BadNetworkApiError extends DioException {
  final String apiUrl;
  final int? statusCode;
  final DioException dioError;

  BadNetworkApiError({
    required this.apiUrl,
    required this.statusCode,
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}
