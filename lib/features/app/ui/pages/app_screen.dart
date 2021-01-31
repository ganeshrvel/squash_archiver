import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/l10n/l10n.dart';
import 'package:squash_archiver/common/l10n/l10n_helpers.dart';
import 'package:squash_archiver/common/router/router.gr.dart' as router_gen;
import 'package:squash_archiver/common/router/router_auth_guard.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/constants/strings.dart';
import 'package:squash_archiver/features/app/ui/store/app_store.dart';
import 'package:squash_archiver/widgets/common_widget/custom_scroll_behavior.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class AppScreen extends StatelessWidget {
  final _appStore = getIt<AppStore>();

  void setErrorBuilder() {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      // @todo add oops something went wrong screen
      return const Scaffold(
        body: Center(
          child: Textography(
            'Oops.. Some error occured.',
            variant: TextVariant.body1,
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (!_appStore.isAppSettingsLoaded) {
          return Center(
            child: Container(),
          );
        }

        return Portal(
          child: MaterialApp(
            debugShowCheckedModeBanner: env.config.debugShowCheckedModeBanner,
            debugShowMaterialGrid: env.config.debugShowMaterialGrid,
            builder: (context, nativeNavigator) {
              setErrorBuilder();

              return ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: CustomScrollBehavior(
                  child: ExtendedNavigator<router_gen.Router>(
                    initialRoute: router_gen.Routes.fileExplorerScreen,
                    router: router_gen.Router(),
                    guards: [
                      RouterAuthGuard(),
                    ],
                  ),
                ),
              );
            },
            title: Strings.APP_NAME,
            //theme: getAppThemeData(_appStore.theme.mode),
            theme: getAppThemeData(ThemeMode.dark),
            locale: Locale(
              _appStore.language.locale,
              _appStore.language.countryCode,
            ),
            supportedLocales: supportedL10nLanguages
                .map(
                    (language) => Locale(language.locale, language.countryCode))
                .toList(),
            localizationsDelegates: [
              L10n.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) {
                return supportedLocales.first;
              }

              // Check if the current device locale is supported
              return supportedLocales.firstWhere(
                (supportedLocale) =>
                    supportedLocale.languageCode == locale.languageCode,
                orElse: () => supportedLocales.first,
              );
            },
          ),
        );
      },
    );
  }
}
