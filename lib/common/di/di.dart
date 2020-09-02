import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/di/di.iconfig.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> getItInit() => $initGetIt(getIt);

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
