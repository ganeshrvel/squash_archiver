// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';

import '../../features/home/ui/pages/file_explorer_screen.dart';
import '../../features/page_not_found/ui/pages/page_not_found_screen.dart';
import '../../features/splash/ui/pages/splash_screen.dart';

class Routes {
  static const String splashScreen = '/splash-screen';
  static const String fileExplorerScreen = '/';
  static const String pageNotFoundScreen = '*';
  static const all = <String>{
    splashScreen,
    fileExplorerScreen,
    pageNotFoundScreen,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashScreen, page: SplashScreen),
    RouteDef(Routes.fileExplorerScreen, page: FileExplorerScreen),
    RouteDef(Routes.pageNotFoundScreen, page: PageNotFoundScreen),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashScreen: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const SplashScreen(),
        settings: data,
      );
    },
    FileExplorerScreen: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const FileExplorerScreen(),
        settings: data,
      );
    },
    PageNotFoundScreen: (data) {
      final args = data.getArgs<PageNotFoundScreenArguments>(nullOk: false);
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => PageNotFoundScreen(args.routeName),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// PageNotFoundScreen arguments holder class
class PageNotFoundScreenArguments {
  final String routeName;
  PageNotFoundScreenArguments({@required this.routeName});
}
