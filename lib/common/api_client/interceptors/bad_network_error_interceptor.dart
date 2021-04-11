import 'dart:io';

import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/bad_network_api_error.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/network/network_info.dart';
import 'package:squash_archiver/utils/utils/api.dart';

class BadNetworkErrorInterceptor extends Interceptor {
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();

  @override
  Future onError(DioError error, ErrorInterceptorHandler handler) async {
    final _apiUrl = getApiUrl(error);

    if (error is SocketException) {
      return BadNetworkApiError(
        apiUrl: _apiUrl,
        statusCode: error.response.statusCode,
      );
    }

    if (error.response == null && !await _networkInfo.isConnected) {
      return BadNetworkApiError(
        apiUrl: _apiUrl,
        statusCode: error?.response?.statusCode ?? 0,
      );
    }

    return null;
  }
}
