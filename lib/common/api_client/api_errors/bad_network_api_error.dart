import 'package:dio/dio.dart';

class BadNetworkApiError extends DioError {
  final String apiUrl;
  final int? statusCode;
  final DioError dioError;

  BadNetworkApiError({
    required this.apiUrl,
    required this.statusCode,
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}
