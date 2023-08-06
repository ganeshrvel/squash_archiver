import 'package:dio/dio.dart';

String getApiUrl(DioException dioError) {
  return (dioError.response?.requestOptions.uri ?? '').toString();
}
