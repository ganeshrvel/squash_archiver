// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStoreBase, Store {
  Computed<bool>? _$isAppSettingsLoadedComputed;

  @override
  bool get isAppSettingsLoaded => (_$isAppSettingsLoadedComputed ??=
          Computed<bool>(() => super.isAppSettingsLoaded,
              name: '_AppStoreBase.isAppSettingsLoaded'))
      .value;

  late final _$windowStateAtom =
      Atom(name: '_AppStoreBase.windowState', context: context);

  @override
  WindowState? get windowState {
    _$windowStateAtom.reportRead();
    return super.windowState;
  }

  @override
  set windowState(WindowState? value) {
    _$windowStateAtom.reportWrite(value, super.windowState, () {
      super.windowState = value;
    });
  }

  late final _$themeAtom = Atom(name: '_AppStoreBase.theme', context: context);

  @override
  ThemeModel? get theme {
    _$themeAtom.reportRead();
    return super.theme;
  }

  @override
  set theme(ThemeModel? value) {
    _$themeAtom.reportWrite(value, super.theme, () {
      super.theme = value;
    });
  }

  late final _$setAppThemeAsyncAction =
      AsyncAction('_AppStoreBase.setAppTheme', context: context);

  @override
  Future<void> setAppTheme(ThemeModel data) {
    return _$setAppThemeAsyncAction.run(() => super.setAppTheme(data));
  }

  late final _$getAppThemeAsyncAction =
      AsyncAction('_AppStoreBase.getAppTheme', context: context);

  @override
  Future<ThemeModel?> getAppTheme() {
    return _$getAppThemeAsyncAction.run(() => super.getAppTheme());
  }

  late final _$toggleAppThemeAsyncAction =
      AsyncAction('_AppStoreBase.toggleAppTheme', context: context);

  @override
  Future<void> toggleAppTheme() {
    return _$toggleAppThemeAsyncAction.run(() => super.toggleAppTheme());
  }

  late final _$setWindowStateAsyncAction =
      AsyncAction('_AppStoreBase.setWindowState', context: context);

  @override
  Future<void> setWindowState(WindowState value) {
    return _$setWindowStateAsyncAction.run(() => super.setWindowState(value));
  }

  @override
  String toString() {
    return '''
windowState: ${windowState},
theme: ${theme},
isAppSettingsLoaded: ${isAppSettingsLoaded}
    ''';
  }
}
