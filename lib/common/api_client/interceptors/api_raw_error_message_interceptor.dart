import 'package:dio/dio.dart';
import 'package:squash_archiver/common/models/api_response_data_model.dart';
import 'package:squash_archiver/utils/log/log.dart';

class ApiRawErrorMessageInterceptor extends Interceptor {
  @override
  Future onError(DioError _dioError) async {
    final _responseData = _dioError?.response?.data;

    if (_responseData != null) {
      final _apiErrorData = ApiResponseDataModel.fromJson(
        _responseData as Map<String, dynamic>,
      );

      if (_apiErrorData?.error != null ||
          _apiErrorData?.rawError != null ||
          _apiErrorData?.success == false) {
        const _title = 'The API call threw an error.';

        log.error(
          _title,
          error: _apiErrorData?.rawError ?? _apiErrorData?.error,
        );
      }
    }

    return null;
  }
}
