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
