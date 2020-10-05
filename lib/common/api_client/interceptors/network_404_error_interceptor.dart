import 'package:dio/dio.dart';
import 'package:squash_archiver/common/api_client/api_errors/network_404_api_error.dart';


class Network404Interceptor extends Interceptor {
  @override
  Future onError(DioError error) async {
    if (error.response != null) {
      if (error.response.statusCode == 404) {
        return Network404Error(
          errorMessage: 'A 404 Network error was encountered',
          apiUrl: '${error.response.request.uri}',
          statusCode: error?.response?.statusCode ?? 0,
        );
      }
    }

    return null;
  }
}
