import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class {{FeatureNameUpper}}Controller {
	final {{FeatureNameUpper}}Repository _{{featureNameLower}}Repository;

	{{FeatureNameUpper}}Controller(
			this._{{featureNameLower}}Repository,
	);

	Future<DC<Exception, {{ModelClassName}}Response>> {{methodName}}(
		{{ModelClassName}}Request params,) async {
	  return _{{featureNameLower}}Repository.{{methodName}}(params);
	}
}
