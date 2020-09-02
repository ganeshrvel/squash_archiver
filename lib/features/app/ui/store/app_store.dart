///
/// This is an app wide store
///

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/exceptions/cache_exception.dart';
import 'package:squash_archiver/features/app/data/models/language_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/l10n/l10n_helpers.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/features/app/data/controllers/app_controller.dart';
import 'package:squash_archiver/utils/alerts/alerts.dart';
import 'package:squash_archiver/utils/log/log.dart';

part 'app_store.g.dart';

enum AppSettingsTypes {
  LANGUAGE,
  THEME,
}

@lazySingleton
class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  final AppController appController;

  final Alerts _alerts;

  _AppStoreBase(this.appController, this._alerts) {
    init();
  }

  Future<void> init() async {
    getAppLanguage();
    getAppTheme();
  }

  @observable
  LanguageModel language;

  @observable
  ThemeModel theme;

  @computed
  bool get isAppSettingsLoaded {
    return language != null && theme != null;
  }

  @action
  Future<void> setAppLanguage(
    BuildContext context,
    LanguageModel languageData,
  ) async {
    final appData = await appController.setAppLanguageData(languageData);

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          _alerts.setException(context, error);
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
    final appData = await appController.getAppLanguageData();

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
  Future<void> setAppTheme(
    BuildContext context,
    ThemeModel data,
  ) async {
    final appData = await appController.setAppThemeData(data);

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          _alerts.setException(context, error);
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
  Future<void> getAppTheme() async {
    final appData = await appController.getAppThemeData();

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          log.error(
            title: '_AppStoreBase.getAppTheme',
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
