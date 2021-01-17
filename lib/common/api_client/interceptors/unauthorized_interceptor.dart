import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/unauthorized_api_error.dart';
import 'package:squash_archiver/utils/utils/api.dart';

class UnauthorizedInterceptor extends Interceptor {
  @override
  Future onError(DioError error) async {
    if (error.response?.statusCode == 401) {
      final _apiUrl = getApiUrl(error);

      return UnauthorizedApiError(
        apiUrl: _apiUrl,
        statusCode: error?.response?.statusCode ?? 0,
      );
    }

    return null;
  }
}
