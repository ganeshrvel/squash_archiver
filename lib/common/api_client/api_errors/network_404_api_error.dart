import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class Network404Error extends DioError {
  final String errorMessage;
  final String apiUrl;
  final int statusCode;

  Network404Error({
    @required this.errorMessage,
    @required this.apiUrl,
    @required this.statusCode,
  });
}
