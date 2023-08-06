///
/// This is an app wide store
///
import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/exceptions/cache_exception.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/features/app/data/controllers/app_controller.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';
import 'package:squash_archiver/utils/log/log.dart';
import 'package:squash_archiver/widget_extends/material.dart';

part 'app_store.g.dart';

enum WindowState {
  Focused,
  Blurred,
}

@LazySingleton()
class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  final AppController _appController;

  _AppStoreBase(this._appController) {
    init();
  }

  Future<void> init() async {
    getAppTheme();
  }

  @observable
  WindowState? windowState;

  @observable
  ThemeModel? theme;

  @computed
  bool get isAppSettingsLoaded {
    return theme != null;
  }

  @action
  Future<void> setAppTheme(ThemeModel data) async {
    final appData = await _appController.setAppThemeData(data);

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          log.error(
            title: 'AppStore.setAppTheme',
            error: error,
          );
        }

        theme = getDefaultAppTheme();
      },
      onData: (data) {
        theme = data;
      },
      onNoData: () {
        theme = getDefaultAppTheme();
      },
    );
  }

  @action
  Future<ThemeModel?> getAppTheme() async {
    final appData = await _appController.getAppThemeData();

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          log.error(
            title: 'AppStore.getAppTheme',
            error: error,
          );
        }

        theme = getDefaultAppTheme();
      },
      onData: (data) {
        theme = data;
      },
      onNoData: () {
        theme = getDefaultAppTheme();
      },
    );

    return theme;
  }

  @action
  Future<void> toggleAppTheme() async {
    final _currentAppTheme = await getAppTheme();
    final _nextAppTheme = _currentAppTheme?.mode == ThemeMode.dark
        ? const ThemeModel(mode: ThemeMode.light)
        : const ThemeModel(mode: ThemeMode.dark);

    final appData = await _appController.setAppThemeData(_nextAppTheme);

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          log.error(
            title: 'AppStore.setAppTheme',
            error: error,
          );
        }

        theme = getDefaultAppTheme();
      },
      onData: (data) {
        theme = data;
      },
      onNoData: () {
        theme = getDefaultAppTheme();
      },
    );
  }

  @action
  Future<void> setWindowState(WindowState value) async {
    windowState = value;
  }
}
