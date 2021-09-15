// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen.dart'
    as _i4;
import 'package:squash_archiver/features/page_not_found/ui/pages/page_not_found_screen.dart'
    as _i5;
import 'package:squash_archiver/features/splash/ui/pages/splash_screen.dart'
    as _i3;

class RootRouter extends _i1.RootStackRouter {
  RootRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i3.SplashScreen();
        }),
    FileExplorerScreenRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<FileExplorerScreenRouteArgs>(
              orElse: () => const FileExplorerScreenRouteArgs());
          return _i4.FileExplorerScreen(key: args.key, dummy: args.dummy);
        }),
    PageNotFoundScreenRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i5.PageNotFoundScreen();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig('/#redirect',
            path: '/', redirectTo: '/fileExplorer', fullMatch: true),
        _i1.RouteConfig(SplashScreenRoute.name, path: '/splash'),
        _i1.RouteConfig(FileExplorerScreenRoute.name, path: '/fileExplorer'),
        _i1.RouteConfig(PageNotFoundScreenRoute.name, path: '*')
      ];
}

class SplashScreenRoute extends _i1.PageRouteInfo<void> {
  const SplashScreenRoute() : super(name, path: '/splash');

  static const String name = 'SplashScreenRoute';
}

class FileExplorerScreenRoute
    extends _i1.PageRouteInfo<FileExplorerScreenRouteArgs> {
  FileExplorerScreenRoute({_i2.Key? key, String? dummy})
      : super(name,
            path: '/fileExplorer',
            args: FileExplorerScreenRouteArgs(key: key, dummy: dummy));

  static const String name = 'FileExplorerScreenRoute';
}

class FileExplorerScreenRouteArgs {
  const FileExplorerScreenRouteArgs({this.key, this.dummy});

  final _i2.Key? key;

  final String? dummy;
}

class PageNotFoundScreenRoute extends _i1.PageRouteInfo<void> {
  const PageNotFoundScreenRoute() : super(name, path: '*');

  static const String name = 'PageNotFoundScreenRoute';
}
