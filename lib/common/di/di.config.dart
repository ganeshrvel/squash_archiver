// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:archiver_ffi/archiver_ffi.dart' as _i6;
import 'package:data_connection_checker/data_connection_checker.dart' as _i7;
import 'package:dio/dio.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i13;
import 'package:shared_preferences/shared_preferences.dart' as _i16;
import 'package:squash_archiver/common/api_client/api_client.dart' as _i17;
import 'package:squash_archiver/common/di/app_theme_di.dart' as _i28;
import 'package:squash_archiver/common/di/archiver_ffi_di.dart' as _i29;
import 'package:squash_archiver/common/di/dio_di.dart' as _i31;
import 'package:squash_archiver/common/di/logger_di.dart' as _i32;
import 'package:squash_archiver/common/di/network_info_di.dart' as _i30;
import 'package:squash_archiver/common/di/shared_preferences_di.dart' as _i33;
import 'package:squash_archiver/common/helpers/flushbar_helper.dart' as _i11;
import 'package:squash_archiver/common/network/network_info.dart' as _i14;
import 'package:squash_archiver/common/themes/app_theme.dart' as _i4;
import 'package:squash_archiver/constants/env.dart' as _i10;
import 'package:squash_archiver/features/app/data/controllers/app_controller.dart'
    as _i24;
import 'package:squash_archiver/features/app/data/data_sources/app_local_data_source.dart'
    as _i18;
import 'package:squash_archiver/features/app/data/repositories/app_repository.dart'
    as _i19;
import 'package:squash_archiver/features/app/ui/store/app_store.dart' as _i25;
import 'package:squash_archiver/features/home/data/controllers/file_explorer_controller.dart'
    as _i26;
import 'package:squash_archiver/features/home/data/data_sources/archive_data_source.dart'
    as _i5;
import 'package:squash_archiver/features/home/data/data_sources/local_data_source.dart'
    as _i12;
import 'package:squash_archiver/features/home/data/repositories/file_explorer_repository.dart'
    as _i21;
import 'package:squash_archiver/services/analytics_service.dart' as _i3;
import 'package:squash_archiver/services/crashes_service.dart' as _i20;
import 'package:squash_archiver/services/pushes_service.dart' as _i15;
import 'package:squash_archiver/utils/alerts/alerts.dart' as _i27;
import 'package:squash_archiver/utils/alerts/alerts_helper.dart' as _i23;
import 'package:squash_archiver/utils/device_details/device_details.dart'
    as _i8;
import 'package:squash_archiver/utils/log/log.dart' as _i22;

const String _dev = 'dev';
const String _test = 'test';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appThemeDi = _$AppThemeDi();
  final archiverFfiDi = _$ArchiverFfiDi();
  final networkInfoDi = _$NetworkInfoDi();
  final dioDi = _$DioDi();
  final loggerDi = _$LoggerDi();
  final sharedPreferencesDi = _$SharedPreferencesDi();
  gh.lazySingleton<_i3.AnalyticsService>(() => _i3.AnalyticsService());
  gh.lazySingleton<_i4.AppTheme>(() => appThemeDi.lightTheme,
      instanceName: 'lightTheme');
  gh.lazySingleton<_i4.AppTheme>(() => appThemeDi.darkTheme,
      instanceName: 'darkTheme');
  gh.lazySingleton<_i5.ArchiveDataSource>(() => _i5.ArchiveDataSource());
  gh.lazySingleton<_i6.ArchiverFfi>(() => archiverFfiDi.archiverFfi,
      registerFor: {_dev});
  gh.lazySingleton<_i6.ArchiverFfi>(() => archiverFfiDi.archiverFfiTest,
      registerFor: {_test});
  gh.lazySingleton<_i7.DataConnectionChecker>(
      () => networkInfoDi.dataConnectionChecker);
  gh.lazySingleton<_i8.DeviceDetails>(() => _i8.DeviceDetails());
  gh.lazySingleton<_i9.Dio>(() => dioDi.dio);
  gh.lazySingleton<_i10.Env>(() => _i10.Env());
  gh.lazySingleton<_i11.FlushbarHelper>(() => _i11.FlushbarHelper());
  gh.lazySingleton<_i12.LocalDataSource>(() => _i12.LocalDataSource());
  gh.lazySingleton<_i13.Logger>(() => loggerDi.logger);
  gh.lazySingleton<_i14.NetworkInfo>(
      () => _i14.NetworkInfo(get<_i7.DataConnectionChecker>()));
  gh.lazySingleton<_i15.PushesService>(() => _i15.PushesService());
  await gh.factoryAsync<_i16.SharedPreferences>(
      () => sharedPreferencesDi.sharedPreferences,
      preResolve: true);
  gh.lazySingleton<_i17.ApiClient>(() => _i17.ApiClient(get<_i9.Dio>()));
  gh.lazySingleton<_i18.AppLocalDataSource>(
      () => _i18.AppLocalDataSource(get<_i16.SharedPreferences>()));
  gh.lazySingleton<_i19.AppRepository>(
      () => _i19.AppRepository(get<_i18.AppLocalDataSource>()));
  gh.lazySingleton<_i20.CrashesService>(
      () => _i20.CrashesService(get<_i8.DeviceDetails>()));
  gh.lazySingleton<_i21.FileExplorerRepository>(() =>
      _i21.FileExplorerRepository(
          get<_i12.LocalDataSource>(), get<_i5.ArchiveDataSource>()));
  gh.lazySingleton<_i22.Log>(
      () => _i22.Log(get<_i13.Logger>(), get<_i20.CrashesService>()));
  gh.lazySingleton<_i23.AlertsHelper>(
      () => _i23.AlertsHelper(get<_i20.CrashesService>()));
  gh.lazySingleton<_i24.AppController>(
      () => _i24.AppController(get<_i19.AppRepository>()));
  gh.lazySingleton<_i25.AppStore>(
      () => _i25.AppStore(get<_i24.AppController>()));
  gh.lazySingleton<_i26.FileExplorerController>(
      () => _i26.FileExplorerController(get<_i21.FileExplorerRepository>()));
  gh.lazySingleton<_i27.Alerts>(
      () => _i27.Alerts(get<_i23.AlertsHelper>(), get<_i11.FlushbarHelper>()));
  return get;
}

class _$AppThemeDi extends _i28.AppThemeDi {}

class _$ArchiverFfiDi extends _i29.ArchiverFfiDi {}

class _$NetworkInfoDi extends _i30.NetworkInfoDi {}

class _$DioDi extends _i31.DioDi {}

class _$LoggerDi extends _i32.LoggerDi {}

class _$SharedPreferencesDi extends _i33.SharedPreferencesDi {}
