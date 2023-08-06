import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/features/app/data/data_sources/app_local_data_source.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';

@LazySingleton()
class AppRepository {
  final AppLocalDataSource _appLocalDataSource;

  AppRepository(
    this._appLocalDataSource,
  );

  Future<DC<Exception, ThemeModel>> getAppThemeData() async {
    return _appLocalDataSource.getAppThemeData();
  }

  Future<DC<Exception, ThemeModel>> setAppThemeData(
    ThemeModel data,
  ) async {
    return _appLocalDataSource.setAppThemeCache(data);
  }

  Future<DC<Exception, bool>> deleteAppThemeData() async {
    return _appLocalDataSource.deleteAppThemeCache();
  }
}
