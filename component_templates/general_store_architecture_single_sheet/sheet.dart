import 'package:data_channel/data_channel.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:mobx/mobx.dart';

part '{{screen_file_name}}_store.g.dart';

class {{ScreenClassName}}Store = _{{ScreenClassName}}StoreBase with _${{ScreenClassName}}Store;

abstract class _{{ScreenClassName}}StoreBase with Store {
  final {{FeatureNameUpper}}Controller _{{featureNameLower}}Controller = getIt<{{FeatureNameUpper}}Controller>();

  @observable
  ObservableFuture<DC<Exception, {{ModelClassName}}Response>> {{mobxParam}}Future;
  @observable
  {{ModelClassName}}Response {{mobxParam}};
  @observable
  Exception {{mobxParam}}Exception;

  @computed
  bool get is{{MobxParamUpper}}Loading {
    return isStateLoading({{mobxParam}}Future);
  }

  @action
  Future<void> {{methodName}}({{ModelClassName}}Request params,) async {
    {{mobxParam}}Exception =  null;

    {{mobxParam}}Future = ObservableFuture(_{{featureNameLower}}Controller.{{methodName}}(params));
    final _{{methodName}}Data = await {{mobxParam}}Future;

    _{{methodName}}Data.pick(
      onError: (error) {
        {{mobxParam}} = null;

        {{mobxParam}}Exception =  error;
      },
      onData: (data) {
        {{mobxParam}} = data;

        {{mobxParam}}Exception =  null;
      },
      onNoData: () {
        {{mobxParam}} = null;

        {{mobxParam}}Exception =  null;
      },
    );
  }
}

// todo {{featureNameLower}}Controller
Future<DC<Exception, {{ModelClassName}}Response>> {{methodName}}(
		{{ModelClassName}}Request params,) async {
	return _{{featureNameLower}}Repository.{{methodName}}(params);
}

// todo {{featureNameLower}}Repository
Future<DC<Exception, {{ModelClassName}}Response>> {{methodName}}(
	{{ModelClassName}}Request params,) async {
  return _{{featureNameLower}}RemoteDataSource.{{methodName}}(params);
}

// todo _{{featureNameLower}}RemoteDataSource
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

// request model

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part '{{model_file_name}}_request.g.dart';

@JsonSerializable(nullable: false)
class {{ModelClassName}}Request extends Equatable {
  final String dummy;

  const {{ModelClassName}}Request({
    @required this.dummy,
  });

  Map<String, dynamic> toJson() => _${{ModelClassName}}RequestToJson(this);

  @override
  List<Object> get props => [dummy];
}

// todo response model

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part '{{model_file_name}}_response.g.dart';

@JsonSerializable(nullable: true)
class {{ModelClassName}}Response extends Equatable {
  final String dummy;

  const {{ModelClassName}}Response({
    @required this.dummy,
  });

  factory {{ModelClassName}}Response.fromJson(Map<String, dynamic> json) =>
      _${{ModelClassName}}ResponseFromJson(json);

  Map<String, dynamic> toJson() => _${{ModelClassName}}ResponseToJson(this);

  @override
  List<Object> get props => [dummy];
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  _disposers ??= [
		reaction(
				(_) => _{{screenClassNameLower}}Store.{{mobxParam}}Exception,
				(Exception exception) {
					throwException(context, exception);
				},
		),
  ];
}
