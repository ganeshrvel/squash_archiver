// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i6;
import 'package:squash_archiver/common/router/router_auth_guard.dart' as _i2;
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen.dart'
    as _i4;
import 'package:squash_archiver/features/page_not_found/ui/pages/page_not_found_screen.dart'
    as _i5;
import 'package:squash_archiver/features/splash/ui/pages/splash_screen.dart'
    as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter({required this.routerAuthGuard});

  final _i2.RouterAuthGuard routerAuthGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashScreenRoute.name: (entry) {
      return _i1.AdaptivePage(entry: entry, child: const _i3.SplashScreen());
    },
    FileExplorerScreenRoute.name: (entry) {
      var args = entry.routeData.argsAs<FileExplorerScreenRouteArgs>(
          orElse: () => FileExplorerScreenRouteArgs());
      return _i1.AdaptivePage(
          entry: entry,
          child: _i4.FileExplorerScreen(key: args.key, dummy: args.dummy));
    },
    PageNotFoundScreenRoute.name: (entry) {
      var args = entry.routeData.argsAs<PageNotFoundScreenRouteArgs>();
      return _i1.AdaptivePage(
          entry: entry, child: _i5.PageNotFoundScreen(args.routeName));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashScreenRoute.name,
            path: '/splash-screen', guards: [routerAuthGuard]),
        _i1.RouteConfig(FileExplorerScreenRoute.name,
            path: '/', guards: [routerAuthGuard]),
        _i1.RouteConfig(PageNotFoundScreenRoute.name, path: '*')
      ];
}

class SplashScreenRoute extends _i1.PageRouteInfo {
  const SplashScreenRoute() : super(name, path: '/splash-screen');

  static const String name = 'SplashScreenRoute';
}

class FileExplorerScreenRoute
    extends _i1.PageRouteInfo<FileExplorerScreenRouteArgs> {
  FileExplorerScreenRoute({_i6.Key? key, String? dummy})
      : super(name,
            path: '/',
            args: FileExplorerScreenRouteArgs(key: key, dummy: dummy));

  static const String name = 'FileExplorerScreenRoute';
}

class FileExplorerScreenRouteArgs {
  const FileExplorerScreenRouteArgs({this.key, this.dummy});

  final _i6.Key? key;

  final String? dummy;
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
