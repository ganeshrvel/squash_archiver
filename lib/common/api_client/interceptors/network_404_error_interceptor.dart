import 'package:dio/dio.dart';

import 'package:squash_archiver/common/api_client/api_errors/network_404_api_error.dart';

class Network404Interceptor extends Interceptor {
  @override
  Future onError(DioError error) async {
    if (error.response != null) {
      if (error.response.statusCode == 404) {
        return Network404Error(
          errorMessage: '404 - API endpoint not found',
          apiUrl: '${error.response.request.uri}',
        );
      }
    }

    return null;
  }
}
