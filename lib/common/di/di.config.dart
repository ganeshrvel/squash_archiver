// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:archiver_ffi/archiver_ffi.dart' as _i7;
import 'package:data_connection_checker/data_connection_checker.dart' as _i8;
import 'package:dio/dio.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i14;
import 'package:shared_preferences/shared_preferences.dart' as _i17;
import 'package:squash_archiver/common/api_client/api_client.dart' as _i18;
import 'package:squash_archiver/common/di/archiver_ffi_di.dart' as _i31;
import 'package:squash_archiver/common/di/dio_di.dart' as _i30;
import 'package:squash_archiver/common/di/logger_di.dart' as _i29;
import 'package:squash_archiver/common/di/network_info_di.dart' as _i33;
import 'package:squash_archiver/common/di/shared_preferences_di.dart' as _i32;
import 'package:squash_archiver/common/network/network_info.dart' as _i15;
import 'package:squash_archiver/common/router/app_router.dart' as _i5;
import 'package:squash_archiver/constants/env.dart' as _i11;
import 'package:squash_archiver/features/app/data/controllers/app_controller.dart'
    as _i25;
import 'package:squash_archiver/features/app/data/data_sources/app_local_data_source.dart'
    as _i19;
import 'package:squash_archiver/features/app/data/repositories/app_repository.dart'
    as _i20;
import 'package:squash_archiver/features/app/ui/store/app_store.dart' as _i26;
import 'package:squash_archiver/features/home/data/controllers/file_explorer_controller.dart'
    as _i27;
import 'package:squash_archiver/features/home/data/data_sources/archive_data_source.dart'
    as _i6;
import 'package:squash_archiver/features/home/data/data_sources/local_data_source.dart'
    as _i13;
import 'package:squash_archiver/features/home/data/repositories/file_explorer_repository.dart'
    as _i22;
import 'package:squash_archiver/helpers/flushbar_helper.dart' as _i12;
import 'package:squash_archiver/services/analytics_service.dart' as _i3;
import 'package:squash_archiver/services/crashes_service.dart' as _i21;
import 'package:squash_archiver/services/pushes_service.dart' as _i16;
import 'package:squash_archiver/utils/device_details/app_meta_info.dart' as _i4;
import 'package:squash_archiver/utils/device_details/device_details.dart'
    as _i9;
import 'package:squash_archiver/utils/log/log.dart' as _i23;
import 'package:squash_archiver/widgets/alerts/alerts.dart' as _i28;
import 'package:squash_archiver/widgets/alerts/alerts_helper.dart' as _i24;

const String _dev = 'dev';
const String _test = 'test';

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final archiverFfiDi = _$ArchiverFfiDi();
    final networkInfoDi = _$NetworkInfoDi();
    final dioDi = _$DioDi();
    final loggerDi = _$LoggerDi();
    final sharedPreferencesDi = _$SharedPreferencesDi();
    gh.lazySingleton<_i3.AnalyticsService>(() => _i3.AnalyticsService());
    gh.lazySingleton<_i4.AppMetaInfo>(() => _i4.AppMetaInfo());
    gh.lazySingleton<_i5.AppRouter>(() => _i5.AppRouter());
    gh.lazySingleton<_i6.ArchiveDataSource>(() => _i6.ArchiveDataSource());
    gh.lazySingleton<_i7.ArchiverFfi>(
      () => archiverFfiDi.archiverFfi,
      registerFor: {_dev},
    );
    gh.lazySingleton<_i7.ArchiverFfi>(
      () => archiverFfiDi.archiverFfiTest,
      registerFor: {_test},
    );
    gh.lazySingleton<_i8.DataConnectionChecker>(
        () => networkInfoDi.dataConnectionChecker);
    gh.lazySingleton<_i9.DeviceDetails>(() => _i9.DeviceDetails());
    gh.lazySingleton<_i10.Dio>(() => dioDi.dio);
    gh.lazySingleton<_i11.Env>(() => _i11.Env());
    gh.lazySingleton<_i12.FlushbarHelper>(() => _i12.FlushbarHelper());
    gh.lazySingleton<_i13.LocalDataSource>(() => _i13.LocalDataSource());
    gh.lazySingleton<_i14.Logger>(() => loggerDi.logger);
    gh.lazySingleton<_i15.NetworkInfo>(
        () => _i15.NetworkInfo(gh<_i8.DataConnectionChecker>()));
    gh.lazySingleton<_i16.PushesService>(() => _i16.PushesService());
    await gh.factoryAsync<_i17.SharedPreferences>(
      () => sharedPreferencesDi.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i18.ApiClient>(() => _i18.ApiClient(gh<_i10.Dio>()));
    gh.lazySingleton<_i19.AppLocalDataSource>(
        () => _i19.AppLocalDataSource(gh<_i17.SharedPreferences>()));
    gh.lazySingleton<_i20.AppRepository>(
        () => _i20.AppRepository(gh<_i19.AppLocalDataSource>()));
    gh.lazySingleton<_i21.CrashesService>(
        () => _i21.CrashesService(gh<_i9.DeviceDetails>()));
    gh.lazySingleton<_i22.FileExplorerRepository>(
        () => _i22.FileExplorerRepository(
              gh<_i13.LocalDataSource>(),
              gh<_i6.ArchiveDataSource>(),
            ));
    gh.lazySingleton<_i23.Log>(() => _i23.Log(
          gh<_i14.Logger>(),
          gh<_i21.CrashesService>(),
        ));
    gh.lazySingleton<_i24.AlertsHelper>(
        () => _i24.AlertsHelper(gh<_i21.CrashesService>()));
    gh.lazySingleton<_i25.AppController>(
        () => _i25.AppController(gh<_i20.AppRepository>()));
    gh.lazySingleton<_i26.AppStore>(
        () => _i26.AppStore(gh<_i25.AppController>()));
    gh.lazySingleton<_i27.FileExplorerController>(
        () => _i27.FileExplorerController(gh<_i22.FileExplorerRepository>()));
    gh.lazySingleton<_i28.Alerts>(() => _i28.Alerts(
          gh<_i24.AlertsHelper>(),
          gh<_i12.FlushbarHelper>(),
        ));
    return this;
  }
}

class _$LoggerDi extends _i29.LoggerDi {}

class _$DioDi extends _i30.DioDi {}

class _$ArchiverFfiDi extends _i31.ArchiverFfiDi {}

class _$SharedPreferencesDi extends _i32.SharedPreferencesDi {}

class _$NetworkInfoDi extends _i33.NetworkInfoDi {}
