import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class {{FeatureNameUpper}}Repository {
  final {{FeatureNameUpper}}RemoteDataSource _{{featureNameLower}}RemoteDataSource;

  {{FeatureNameUpper}}Repository(
    this._{{featureNameLower}}RemoteDataSource,
  );

	Future<DC<Exception, {{ModelClassName}}Response>> {{methodName}}(
		{{ModelClassName}}Request params,) async {
	  return _{{featureNameLower}}RemoteDataSource.{{methodName}}(params);
	}
}
