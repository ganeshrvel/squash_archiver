import 'package:dio/dio.dart';

class Network404Error extends DioError {
  final String errorMessage;
  final String apiUrl;
  final int statusCode;

  final DioError dioError;

  Network404Error({
    required this.errorMessage,
    required this.apiUrl,
    required this.statusCode,
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}
