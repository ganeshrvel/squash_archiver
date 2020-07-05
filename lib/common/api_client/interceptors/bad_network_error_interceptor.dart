import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/bad_network_api_error.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/network/network_info.dart';

class BadNetworkErrorInterceptor extends Interceptor {
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();

  @override
  Future onError(DioError error) async {
    if (error.response == null && !await _networkInfo.isConnected) {
      return BadNetworkApiError();
    }

    return null;
  }
}
