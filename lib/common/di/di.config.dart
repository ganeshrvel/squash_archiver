// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:squash_archiver/utils/alerts/alerts.dart';
import 'package:squash_archiver/utils/alerts/alerts_helper.dart';
import 'package:squash_archiver/services/analytics_service.dart';
import 'package:squash_archiver/common/api_client/api_client.dart';
import 'package:squash_archiver/features/app/data/controllers/app_controller.dart';
import 'package:squash_archiver/features/app/data/data_sources/app_local_data_source.dart';
import 'package:squash_archiver/features/app/data/repositories/app_repository.dart';
import 'package:squash_archiver/features/app/ui/store/app_store.dart';
import 'package:squash_archiver/features/home/data/data_sources/archive_data_source.dart';
import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:squash_archiver/common/di/archiver_ffi_di.dart';
import 'package:squash_archiver/services/crashes_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:squash_archiver/utils/device_details/device_details.dart';
import 'package:dio/dio.dart';
import 'package:squash_archiver/common/di/dio_di.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/features/home/data/controllers/file_explorer_controller.dart';
import 'package:squash_archiver/features/home/data/repositories/file_explorer_repository.dart';
import 'package:squash_archiver/common/helpers/flushbar_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/features/home/data/data_sources/local_data_source.dart';
import 'package:squash_archiver/utils/log/log.dart';
import 'package:logger/logger.dart';
import 'package:squash_archiver/common/di/logger_di.dart';
import 'package:squash_archiver/common/network/network_info.dart';
import 'package:squash_archiver/common/di/network_info_di.dart';
import 'package:squash_archiver/services/pushes_service.dart';
import 'package:sentry/sentry.dart';
import 'package:squash_archiver/common/di/sentry_di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash_archiver/common/di/shared_preferences_di.dart';

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
  final resolvedSharedPreferences = await sharedPreferencesDi.sharedPreferences;
  gh.factory<SharedPreferences>(() => resolvedSharedPreferences);
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
