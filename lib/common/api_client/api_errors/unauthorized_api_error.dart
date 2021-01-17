import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class UnauthorizedApiError extends DioError {
  final String apiUrl;
  final int statusCode;

  UnauthorizedApiError({
    @required this.apiUrl,
    @required this.statusCode,
  });
}
