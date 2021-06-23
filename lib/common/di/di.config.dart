// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:archiver_ffi/archiver_ffi.dart' as _i7;
import 'package:data_connection_checker/data_connection_checker.dart' as _i8;
import 'package:dio/dio.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i14;
import 'package:shared_preferences/shared_preferences.dart' as _i17;

import '../../constants/env.dart' as _i11;
import '../../features/app/data/controllers/app_controller.dart' as _i25;
import '../../features/app/data/data_sources/app_local_data_source.dart'
    as _i19;
import '../../features/app/data/repositories/app_repository.dart' as _i20;
import '../../features/app/ui/store/app_store.dart' as _i26;
import '../../features/home/data/controllers/file_explorer_controller.dart'
    as _i27;
import '../../features/home/data/data_sources/archive_data_source.dart' as _i6;
import '../../features/home/data/data_sources/local_data_source.dart' as _i13;
import '../../features/home/data/repositories/file_explorer_repository.dart'
    as _i22;
import '../../services/analytics_service.dart' as _i3;
import '../../services/crashes_service.dart' as _i21;
import '../../services/pushes_service.dart' as _i16;
import '../../utils/alerts/alerts.dart' as _i28;
import '../../utils/alerts/alerts_helper.dart' as _i24;
import '../../utils/device_details/app_meta_info.dart' as _i4;
import '../../utils/device_details/device_details.dart' as _i9;
import '../../utils/log/log.dart' as _i23;
import '../api_client/api_client.dart' as _i18;
import '../helpers/flushbar_helper.dart' as _i12;
import '../network/network_info.dart' as _i15;
import '../themes/app_theme.dart' as _i5;
import 'app_theme_di.dart' as _i29;
import 'archiver_ffi_di.dart' as _i30;
import 'dio_di.dart' as _i32;
import 'logger_di.dart' as _i33;
import 'network_info_di.dart' as _i31;
import 'shared_preferences_di.dart' as _i34;

const String _dev = 'dev';
const String _test = 'test';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// an extension to register the provided dependencies inside of [GetIt]
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of provided dependencies inside of [GetIt]
  Future<_i1.GetIt> init(
      {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
    final gh = _i2.GetItHelper(this, environment, environmentFilter);
    final appThemeDi = _$AppThemeDi();
    final archiverFfiDi = _$ArchiverFfiDi();
    final networkInfoDi = _$NetworkInfoDi();
    final dioDi = _$DioDi();
    final loggerDi = _$LoggerDi();
    final sharedPreferencesDi = _$SharedPreferencesDi();
    gh.lazySingleton<_i3.AnalyticsService>(() => _i3.AnalyticsService());
    gh.lazySingleton<_i4.AppMetaInfo>(() => _i4.AppMetaInfo());
    gh.lazySingleton<_i5.AppTheme>(() => appThemeDi.lightTheme,
        instanceName: 'lightTheme');
    gh.lazySingleton<_i5.AppTheme>(() => appThemeDi.darkTheme,
        instanceName: 'darkTheme');
    gh.lazySingleton<_i6.ArchiveDataSource>(() => _i6.ArchiveDataSource());
    gh.lazySingleton<_i7.ArchiverFfi>(() => archiverFfiDi.archiverFfi,
        registerFor: {_dev});
    gh.lazySingleton<_i7.ArchiverFfi>(() => archiverFfiDi.archiverFfiTest,
        registerFor: {_test});
    gh.lazySingleton<_i8.DataConnectionChecker>(
        () => networkInfoDi.dataConnectionChecker);
    gh.lazySingleton<_i9.DeviceDetails>(() => _i9.DeviceDetails());
    gh.lazySingleton<_i10.Dio>(() => dioDi.dio);
    gh.lazySingleton<_i11.Env>(() => _i11.Env());
    gh.lazySingleton<_i12.FlushbarHelper>(() => _i12.FlushbarHelper());
    gh.lazySingleton<_i13.LocalDataSource>(() => _i13.LocalDataSource());
    gh.lazySingleton<_i14.Logger>(() => loggerDi.logger);
    gh.lazySingleton<_i15.NetworkInfo>(
        () => _i15.NetworkInfo(get<_i8.DataConnectionChecker>()));
    gh.lazySingleton<_i16.PushesService>(() => _i16.PushesService());
    await gh.factoryAsync<_i17.SharedPreferences>(
        () => sharedPreferencesDi.sharedPreferences,
        preResolve: true);
    gh.lazySingleton<_i18.ApiClient>(() => _i18.ApiClient(get<_i10.Dio>()));
    gh.lazySingleton<_i19.AppLocalDataSource>(
        () => _i19.AppLocalDataSource(get<_i17.SharedPreferences>()));
    gh.lazySingleton<_i20.AppRepository>(
        () => _i20.AppRepository(get<_i19.AppLocalDataSource>()));
    gh.lazySingleton<_i21.CrashesService>(
        () => _i21.CrashesService(get<_i9.DeviceDetails>()));
    gh.lazySingleton<_i22.FileExplorerRepository>(() =>
        _i22.FileExplorerRepository(
            get<_i13.LocalDataSource>(), get<_i6.ArchiveDataSource>()));
    gh.lazySingleton<_i23.Log>(
        () => _i23.Log(get<_i14.Logger>(), get<_i21.CrashesService>()));
    gh.lazySingleton<_i24.AlertsHelper>(
        () => _i24.AlertsHelper(get<_i21.CrashesService>()));
    gh.lazySingleton<_i25.AppController>(
        () => _i25.AppController(get<_i20.AppRepository>()));
    gh.lazySingleton<_i26.AppStore>(
        () => _i26.AppStore(get<_i25.AppController>()));
    gh.lazySingleton<_i27.FileExplorerController>(
        () => _i27.FileExplorerController(get<_i22.FileExplorerRepository>()));
    gh.lazySingleton<_i28.Alerts>(() =>
        _i28.Alerts(get<_i24.AlertsHelper>(), get<_i12.FlushbarHelper>()));
    return this;
  }
}

class _$AppThemeDi extends _i29.AppThemeDi {}

class _$ArchiverFfiDi extends _i30.ArchiverFfiDi {}

class _$NetworkInfoDi extends _i31.NetworkInfoDi {}

class _$DioDi extends _i32.DioDi {}

class _$LoggerDi extends _i33.LoggerDi {}

class _$SharedPreferencesDi extends _i34.SharedPreferencesDi {}
