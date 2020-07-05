import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class ApiResponseError extends DioError {
  final String errorMessage;

  ApiResponseError({
    @required this.errorMessage,
  });
}
