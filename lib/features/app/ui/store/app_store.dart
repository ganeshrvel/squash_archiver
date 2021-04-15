///
/// This is an app wide store
///

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/exceptions/cache_exception.dart';
import 'package:squash_archiver/features/app/data/models/language_model.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/l10n/l10n_helpers.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/features/app/data/controllers/app_controller.dart';
import 'package:squash_archiver/utils/log/log.dart';

part 'app_store.g.dart';

enum AppSettingsTypes {
  LANGUAGE,
  THEME,
}

@LazySingleton()
class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  final AppController _appController;

  _AppStoreBase(this._appController) {
    init();
  }

  Future<void> init() async {
    getAppLanguage();
    getAppTheme();
  }

  @observable
  LanguageModel? language;

  @observable
  ThemeModel? theme;

  @computed
  bool get isAppSettingsLoaded {
    return language != null && theme != null;
  }

  @action
  Future<void> setAppLanguage(LanguageModel languageData) async {
    final appData = await _appController.setAppLanguageData(languageData);

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          log.error(title: 'AppStore.setAppLanguage', error: error);
        }

        language = getDefaultAppLanguage();

        return;
      },
      onData: (data) {
        language = data;
      },
      onNoData: () {
        language = getDefaultAppLanguage();
      },
    );
  }

  @action
  Future<void> getAppLanguage() async {
    final appData = await _appController.getAppLanguageData();

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          log.error(
            title: '_AppStoreBase.getAppLanguage',
            error: error,
          );
        }

        language = getDefaultAppLanguage();
      },
      onData: (data) {
        language = data;
      },
      onNoData: () {
        language = getDefaultAppLanguage();
      },
    );
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
    final _currentAppTheme = await (getAppTheme() as FutureOr<ThemeModel>);
    final _nextAppTheme = _currentAppTheme.mode == ThemeMode.dark
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
}
