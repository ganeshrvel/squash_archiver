import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/router/root_router.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/constants/strings.dart';
import 'package:squash_archiver/features/app/ui/pages/error_boundary_screen.dart';
import 'package:squash_archiver/features/app/ui/store/app_store.dart';

class AppScreen extends StatelessWidget {
  final AppStore _appStore = getIt<AppStore>();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      debugShowCheckedModeBanner: env.config.debugShowCheckedModeBanner,
      builder: (context, nativeNavigator) {
        return Observer(
          builder: (context) {
            final _windowState = _appStore.windowState;

            var lightTheme = MacosThemeData.light();
            var darkTheme = MacosThemeData.dark();

            if (_windowState == WindowState.Blurred) {
              lightTheme = lightTheme.copyWith(
                primaryColor: const Color.fromRGBO(170, 201, 239, 1),
              );
              darkTheme = darkTheme.copyWith(
                primaryColor: const Color.fromRGBO(70, 70, 70, 1),
              );
            }
            return MacosApp(
              title: Strings.APP_NAME,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: _appStore.theme!.mode,
              debugShowCheckedModeBanner: env.config.debugShowCheckedModeBanner,
              builder: (context, __) {
                if (!_appStore.isAppSettingsLoaded) {
                  return Center(
                    child: Container(),
                  );
                }

                return Portal(
                  child: Builder(
                    builder: (context) {
                      setErrorBuilder();

                      return nativeNavigator ?? Container();
                    },
                  ),
                );
              },
            );
          },
        );
      },
      routeInformationParser: rootRouter.defaultRouteParser(),
      routerDelegate: AutoRouterDelegate(
        rootRouter,
        navigatorObservers: () => [AutoRouteObserver()],
      ),
    );
  }
}
