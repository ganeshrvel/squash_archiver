// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:squash_archiver/features/splash/ui/pages/splash_screen.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen.dart';
import 'package:squash_archiver/features/page_not_found/ui/pages/page_not_found_screen.dart';

abstract class Routes {
  static const splashScreen = '/splash-screen';
  static const fileExplorerScreen = '/';
  static const all = {
    splashScreen,
    fileExplorerScreen,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.splashScreen:
        if (hasInvalidArgs<SplashScreenArguments>(args)) {
          return misTypedArgsRoute<SplashScreenArguments>(args);
        }
        final typedArgs =
            args as SplashScreenArguments ?? SplashScreenArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SplashScreen(key: typedArgs.key),
          settings: settings,
        );
      case Routes.fileExplorerScreen:
        if (hasInvalidArgs<FileExplorerScreenArguments>(args)) {
          return misTypedArgsRoute<FileExplorerScreenArguments>(args);
        }
        final typedArgs = args as FileExplorerScreenArguments ??
            FileExplorerScreenArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FileExplorerScreen(
                  key: typedArgs.key,
                  redirectRouteName: typedArgs.redirectRouteName,
                  redirectRouteArgs: typedArgs.redirectRouteArgs),
          settings: settings,
        );
      default:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PageNotFoundScreen(settings.name),
          settings: settings,
        );
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//SplashScreen arguments holder class
class SplashScreenArguments {
  final Key key;
  SplashScreenArguments({this.key});
}

//FileExplorerScreen arguments holder class
class FileExplorerScreenArguments {
  final Key key;
  final String redirectRouteName;
  final Object redirectRouteArgs;
  FileExplorerScreenArguments(
      {this.key, this.redirectRouteName, this.redirectRouteArgs});
}
