import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/internal_server_api_error.dart';
import 'package:squash_archiver/constants/errors.dart';
import 'package:squash_archiver/utils/utils/api.dart';

// intercept statusCode >= 500 && < 600
class InternalServerErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError _dioError, ErrorInterceptorHandler handler) async {
    if (_dioError.response != null) {
      if (_dioError.response!.statusCode != null &&
          _dioError.response!.statusCode! >= 500 &&
          _dioError.response!.statusCode! < 600) {
        final _apiUrl = getApiUrl(_dioError);

        return InternalServerApiError(
          apiUrl: _apiUrl,
          statusCode: _dioError.response?.statusCode ?? 0,
          error: Errors.INTERNAL_SERVER_MESSAGE,
          errorMessage: Errors.INTERNAL_SERVER_MESSAGE,
          dioError: _dioError,
        );
      }
    }

    return null;
  }
}
