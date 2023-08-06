import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/api_client/api_client.dart';
import 'package:data_channel/data_channel.dart';

@lazySingleton
class {{FeatureNameUpper}}RemoteDataSource {
  	final ApiClient _apiClient;

  	{{FeatureNameUpper}}RemoteDataSource(this._apiClient);

	Future<DC<Exception, {{ModelClassName}}Response>> {{methodName}}(
		{{ModelClassName}}Request request,) async {
	  try {
      final response = await _apiClient.post(
        '{{apiEndpoint}}',
        request.toJson(),
      );

      return DC.data(
        {{ModelClassName}}Response.fromJson(response.data as Map<String, dynamic>),
      );
	  } on Exception catch (e) {
      return DC.error(
        e,
      );
	  }
	}
}
