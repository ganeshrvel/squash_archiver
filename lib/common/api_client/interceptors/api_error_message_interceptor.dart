import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/api_response_error.dart';
import 'package:squash_archiver/common/models/api_response_data_model.dart';
import 'package:squash_archiver/constants/errors.dart';

class ApiErrorMessageInterceptor extends Interceptor {
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
        return ApiResponseError(
          errorMessage: _apiErrorData?.error ?? Errors.UNKNOWN_FAILURE_MESSAGE,
        );
      }
    }

    return null;
  }
}
