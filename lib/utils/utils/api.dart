import 'package:dio/dio.dart';

String getApiUrl(DioError dioError) {
  return (dioError.response?.requestOptions.uri ?? '').toString();
}
