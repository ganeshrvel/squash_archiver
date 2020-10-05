import 'package:dio/dio.dart';

String getApiUrl(DioError dioError) {
  return (dioError?.response?.request?.uri ?? '').toString();
}
