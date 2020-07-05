import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/unauthorized_api_error.dart';

class UnauthorizedInterceptor extends Interceptor {
  @override
  Future onError(DioError error) async {
    if (error.response?.statusCode == 401 ||
        error.response?.statusCode == 403) {
      return UnauthorizedApiError();
    }

    return null;
  }
}
