import 'dart:async';
import 'dart:convert';

import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash_archiver/common/exceptions/cache_exception.dart';
import 'package:squash_archiver/constants/shared_preferences_keys.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';

@LazySingleton()
class AppLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AppLocalDataSource(this._sharedPreferences);

  Future<DC<Exception, ThemeModel>> getAppThemeData() async {
    try {
      final pref = _sharedPreferences;
      final jsonString =
          pref.getString(SharedPreferencesKeys.APP_THEME_SETTING);

      ThemeModel? _data;

      if (jsonString != null) {
        _data = ThemeModel.fromJson(
            json.decode(jsonString) as Map<String, dynamic>);
      }

      return DC.data(
        _data,
      );
    } on Exception catch (e, stackTrace) {
      return DC.error(
        CacheException(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<DC<Exception, ThemeModel>> setAppThemeCache(
    ThemeModel data,
  ) async {
    try {
      final pref = _sharedPreferences;

      await pref.setString(
        SharedPreferencesKeys.APP_THEME_SETTING,
        json.encode(data.toJson()),
      );

      return DC.data(
        data,
      );
    } on Exception catch (e, stackTrace) {
      return DC.error(
        CacheException(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<DC<Exception, bool>> deleteAppThemeCache() async {
    try {
      final pref = _sharedPreferences;

      return DC.data(
        await pref.remove(SharedPreferencesKeys.APP_THEME_SETTING),
      );
    } on Exception catch (e, stackTrace) {
      return DC.error(
        CacheException(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
