import 'package:dio/dio.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future<RequestOptions> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    return options;
  }
}
