import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';
import 'package:squash_archiver/features/app/data/repositories/app_repository.dart';

@LazySingleton()
class AppController {
  final AppRepository _appRepository;

  AppController(this._appRepository);

  Future<DC<Exception, ThemeModel>> getAppThemeData() async {
    return _appRepository.getAppThemeData();
  }

  Future<DC<Exception, ThemeModel>> setAppThemeData(
    ThemeModel data,
  ) async {
    return _appRepository.setAppThemeData(data);
  }

  Future<DC<Exception, bool>> deleteAppThemeData() async {
    return _appRepository.deleteAppThemeData();
  }
}
