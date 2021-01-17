import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/di/di.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: false,
)
Future<void> getItInit(String environment) => $initGetIt(
      getIt,
      environment: environment,
    );

void resetGetIt<T>({
  Object instance,
  String instanceName,
  void Function(T) disposingFunction,
}) {
  getIt.resetLazySingleton<T>(
    instance: instance,
    instanceName: instanceName,
    disposingFunction: disposingFunction,
  );
}
