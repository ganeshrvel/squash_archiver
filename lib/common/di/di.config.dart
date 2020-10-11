// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sentry/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/alerts/alerts.dart';
import '../../utils/alerts/alerts_helper.dart';
import '../../services/analytics_service.dart';
import '../api_client/api_client.dart';
import '../../features/app/data/controllers/app_controller.dart';
import '../../features/app/data/data_sources/app_local_data_source.dart';
import '../../features/app/data/repositories/app_repository.dart';
import '../../features/app/ui/store/app_store.dart';
import '../../features/home/data/data_sources/archive_data_source.dart';
import 'archiver_ffi_di.dart';
import '../../services/crashes_service.dart';
import '../../utils/device_details/device_details.dart';
import 'dio_di.dart';
import '../../constants/env.dart';
import '../../features/home/data/controllers/file_explorer_controller.dart';
import '../../features/home/data/repositories/file_explorer_repository.dart';
import '../helpers/flushbar_helper.dart';
import '../../features/home/data/data_sources/local_data_source.dart';
import '../../utils/log/log.dart';
import 'logger_di.dart';
import '../network/network_info.dart';
import 'network_info_di.dart';
import '../../services/pushes_service.dart';
import 'sentry_di.dart';
import 'shared_preferences_di.dart';

/// Environment names
const _dev = 'dev';
const _test = 'test';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<GetIt> $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) async {
  final gh = GetItHelper(get, environment, environmentFilter);
  final archiverFfiDi = _$ArchiverFfiDi();
  final networkInfoDi = _$NetworkInfoDi();
  final dioDi = _$DioDi();
  final loggerDi = _$LoggerDi();
  final sentryClientDI = _$SentryClientDI();
  final sharedPreferencesDi = _$SharedPreferencesDi();
  gh.lazySingleton<AnalyticsService>(() => AnalyticsService());
  gh.lazySingleton<ArchiverFfi>(() => archiverFfiDi.archiverFfi,
      registerFor: {_dev});
  gh.lazySingleton<ArchiverFfi>(() => archiverFfiDi.archiverFfiTest,
      registerFor: {_test});
  gh.lazySingleton<DataConnectionChecker>(
      () => networkInfoDi.dataConnectionChecker);
  gh.lazySingleton<DeviceDetails>(() => DeviceDetails());
  gh.lazySingleton<Dio>(() => dioDi.dio);
  gh.lazySingleton<Env>(() => Env());
  gh.lazySingleton<FlushbarHelper>(() => FlushbarHelper());
  gh.lazySingleton<LocalDataSource>(() => LocalDataSource());
  gh.lazySingleton<Logger>(() => loggerDi.logger);
  gh.lazySingleton<NetworkInfo>(
      () => NetworkInfo(get<DataConnectionChecker>()));
  gh.lazySingleton<PushesService>(() => PushesService());
  gh.lazySingleton<SentryClient>(() => sentryClientDI.sentryClient);
  final sharedPreferences = await sharedPreferencesDi.sharedPreferences;
  gh.factory<SharedPreferences>(() => sharedPreferences);
  gh.lazySingleton<ApiClient>(() => ApiClient(get<Dio>()));
  gh.lazySingleton<AppLocalDataSource>(
      () => AppLocalDataSource(get<SharedPreferences>()));
  gh.lazySingleton<AppRepository>(
      () => AppRepository(get<AppLocalDataSource>()));
  gh.lazySingleton<ArchiveDataSource>(
      () => ArchiveDataSource(get<ArchiverFfi>()));
  gh.lazySingleton<CrashesService>(() => CrashesService(get<SentryClient>()));
  gh.lazySingleton<FileExplorerRepository>(() =>
      FileExplorerRepository(get<LocalDataSource>(), get<ArchiveDataSource>()));
  gh.lazySingleton<Log>(() => Log(get<Logger>(), get<CrashesService>()));
  gh.lazySingleton<AlertsHelper>(() => AlertsHelper(get<CrashesService>()));
  gh.lazySingleton<AppController>(() => AppController(get<AppRepository>()));
  gh.lazySingleton<FileExplorerController>(
      () => FileExplorerController(get<FileExplorerRepository>()));
  gh.lazySingleton<Alerts>(
      () => Alerts(get<AlertsHelper>(), get<FlushbarHelper>()));
  gh.lazySingleton<AppStore>(
      () => AppStore(get<AppController>(), get<Alerts>()));
  return get;
}

class _$ArchiverFfiDi extends ArchiverFfiDi {}

class _$NetworkInfoDi extends NetworkInfoDi {}

class _$DioDi extends DioDi {}

class _$LoggerDi extends LoggerDi {}

class _$SentryClientDI extends SentryClientDI {}

class _$SharedPreferencesDi extends SharedPreferencesDi {}
