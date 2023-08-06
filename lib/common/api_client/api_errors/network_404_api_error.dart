import 'package:dio/dio.dart';

class Network404Error extends DioException {
  final String errorMessage;
  final String apiUrl;
  final int statusCode;

  final DioException dioError;

  Network404Error({
    required this.errorMessage,
    required this.apiUrl,
    required this.statusCode,
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}
