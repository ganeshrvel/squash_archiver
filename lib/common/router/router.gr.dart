// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i5;
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen.dart'
    as _i3;
import 'package:squash_archiver/features/page_not_found/ui/pages/page_not_found_screen.dart'
    as _i4;
import 'package:squash_archiver/features/splash/ui/pages/splash_screen.dart'
    as _i2;

class Router extends _i1.RootStackRouter {
  Router();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashScreenRoute.name: (entry) {
      return _i1.AdaptivePage(entry: entry, child: const _i2.SplashScreen());
    },
    FileExplorerScreenRoute.name: (entry) {
      var args = entry.routeData.argsAs<FileExplorerScreenRouteArgs>(
          orElse: () => FileExplorerScreenRouteArgs());
      return _i1.AdaptivePage(
          entry: entry,
          child: _i3.FileExplorerScreen(key: args.key, dummy: args.dummy));
    },
    PageNotFoundScreenRoute.name: (entry) {
      var args = entry.routeData.argsAs<PageNotFoundScreenRouteArgs>();
      return _i1.AdaptivePage(
          entry: entry, child: _i4.PageNotFoundScreen(args.routeName));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashScreenRoute.name, path: '/splash-screen'),
        _i1.RouteConfig(FileExplorerScreenRoute.name, path: '/'),
        _i1.RouteConfig(PageNotFoundScreenRoute.name, path: '*')
      ];
}

class SplashScreenRoute extends _i1.PageRouteInfo {
  const SplashScreenRoute() : super(name, path: '/splash-screen');

  static const String name = 'SplashScreenRoute';
}

class FileExplorerScreenRoute
    extends _i1.PageRouteInfo<FileExplorerScreenRouteArgs> {
  FileExplorerScreenRoute({_i5.Key key, String dummy})
      : super(name,
            path: '/',
            args: FileExplorerScreenRouteArgs(key: key, dummy: dummy));

  static const String name = 'FileExplorerScreenRoute';
}

class FileExplorerScreenRouteArgs {
  const FileExplorerScreenRouteArgs({this.key, this.dummy});

  final _i5.Key key;

  final String dummy;
}

class PageNotFoundScreenRoute
    extends _i1.PageRouteInfo<PageNotFoundScreenRouteArgs> {
  PageNotFoundScreenRoute({required String routeName})
      : super(name,
            path: '*', args: PageNotFoundScreenRouteArgs(routeName: routeName));

  static const String name = 'PageNotFoundScreenRoute';
}

class PageNotFoundScreenRouteArgs {
  const PageNotFoundScreenRouteArgs({required this.routeName});

  final String routeName;
}
