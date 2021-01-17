import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class BadNetworkApiError extends DioError {
  final String apiUrl;
  final int statusCode;

  BadNetworkApiError({
    @required this.apiUrl,
    @required this.statusCode,
  });
}
