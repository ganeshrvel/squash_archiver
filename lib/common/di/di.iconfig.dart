// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:squash_archiver/services/analytics_service.dart';
import 'package:squash_archiver/common/di/archiver_ffi_di.dart';
import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:squash_archiver/common/di/network_info_di.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:squash_archiver/utils/device_details/device_details.dart';
import 'package:squash_archiver/common/di/dio_di.dart';
import 'package:dio/dio.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/common/helpers/flushbar_helper.dart';
import 'package:squash_archiver/features/home/data/data_sources/local_data_source.dart';
import 'package:squash_archiver/common/di/logger_di.dart';
import 'package:logger/logger.dart';
import 'package:squash_archiver/common/network/network_info.dart';
import 'package:package_info/package_info.dart';
import 'package:squash_archiver/common/di/package_info_di.dart';
import 'package:squash_archiver/services/pushes_service.dart';
import 'package:squash_archiver/common/di/sentry_di.dart';
import 'package:sentry/src/base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash_archiver/common/di/shared_preferences_di.dart';
import 'package:squash_archiver/common/api_client/api_client.dart';
import 'package:squash_archiver/features/app/data/data_sources/app_local_data_source.dart';
import 'package:squash_archiver/utils/device_details/app_meta_info.dart';
import 'package:squash_archiver/features/app/data/repositories/app_repository.dart';
import 'package:squash_archiver/features/home/data/data_sources/archiver_data_source.dart';
import 'package:squash_archiver/services/crashes_service.dart';
import 'package:squash_archiver/features/home/data/repositories/file_explorer_repository.dart';
import 'package:squash_archiver/utils/log/log.dart';
import 'package:squash_archiver/utils/alerts/alerts_helper.dart';
import 'package:squash_archiver/features/app/data/controllers/app_controller.dart';
import 'package:squash_archiver/features/home/data/controllers/file_explorer_controller.dart';
import 'package:squash_archiver/utils/alerts/alerts.dart';
import 'package:squash_archiver/features/app/ui/store/app_store.dart';
import 'package:get_it/get_it.dart';

Future<void> $initGetIt(GetIt g, {String environment}) async {
  final archiverFfiDi = _$ArchiverFfiDi();
  final networkInfoDi = _$NetworkInfoDi();
  final dioDi = _$DioDi();
  final loggerDi = _$LoggerDi();
  final packageInfoDi = _$PackageInfoDi();
  final sentryClientDI = _$SentryClientDI();
  final sharedPreferencesDi = _$SharedPreferencesDi();
  g.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  g.registerLazySingleton<ArchiverFfi>(() => archiverFfiDi.archiverFfi);
  g.registerLazySingleton<DataConnectionChecker>(
      () => networkInfoDi.dataConnectionChecker);
  g.registerLazySingleton<DeviceDetails>(() => DeviceDetails());
  g.registerLazySingleton<Dio>(() => dioDi.dio);
  g.registerLazySingleton<Env>(() => Env());
  g.registerLazySingleton<FlushbarHelper>(() => FlushbarHelper());
  g.registerLazySingleton<LocalDataSource>(() => LocalDataSource());
  g.registerLazySingleton<Logger>(() => loggerDi.logger);
  g.registerLazySingleton<NetworkInfo>(
      () => NetworkInfo(g<DataConnectionChecker>()));
  final packageInfo = await packageInfoDi.packageInfo;
  g.registerFactory<PackageInfo>(() => packageInfo);
  g.registerLazySingleton<PushesService>(() => PushesService());
  g.registerLazySingleton<SentryClient>(() => sentryClientDI.sentryClient);
  final sharedPreferences = await sharedPreferencesDi.sharedPreferences;
  g.registerFactory<SharedPreferences>(() => sharedPreferences);
  g.registerLazySingleton<ApiClient>(() => ApiClient(g<Dio>()));
  g.registerLazySingleton<AppLocalDataSource>(
      () => AppLocalDataSource(g<SharedPreferences>()));
  g.registerLazySingleton<AppMetaInfo>(() => AppMetaInfo(g<PackageInfo>()));
  g.registerLazySingleton<AppRepository>(
      () => AppRepository(g<AppLocalDataSource>()));
  g.registerLazySingleton<ArchiverDataSource>(
      () => ArchiverDataSource(g<ArchiverFfi>()));
  g.registerLazySingleton<CrashesService>(
      () => CrashesService(g<SentryClient>()));
  g.registerLazySingleton<FileExplorerRepository>(() =>
      FileExplorerRepository(g<LocalDataSource>(), g<ArchiverDataSource>()));
  g.registerLazySingleton<Log>(() => Log(g<Logger>(), g<CrashesService>()));
  g.registerLazySingleton<AlertsHelper>(
      () => AlertsHelper(g<CrashesService>()));
  g.registerLazySingleton<AppController>(
      () => AppController(g<AppRepository>()));
  g.registerLazySingleton<FileExplorerController>(
      () => FileExplorerController(g<FileExplorerRepository>()));
  g.registerLazySingleton<Alerts>(
      () => Alerts(g<AlertsHelper>(), g<FlushbarHelper>()));
  g.registerLazySingleton<AppStore>(
      () => AppStore(g<AppController>(), g<Alerts>()));
}

class _$ArchiverFfiDi extends ArchiverFfiDi {}

class _$NetworkInfoDi extends NetworkInfoDi {}

class _$DioDi extends DioDi {}

class _$LoggerDi extends LoggerDi {}

class _$PackageInfoDi extends PackageInfoDi {}

class _$SentryClientDI extends SentryClientDI {}

class _$SharedPreferencesDi extends SharedPreferencesDi {}
