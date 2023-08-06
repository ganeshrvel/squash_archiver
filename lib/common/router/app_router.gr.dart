// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/cupertino.dart' as _i5;
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen.dart'
    as _i1;
import 'package:squash_archiver/features/page_not_found/ui/pages/page_not_found_screen.dart'
    as _i2;
import 'package:squash_archiver/features/splash/ui/pages/splash_screen.dart'
    as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    FileExplorerScreenRoute.name: (routeData) {
      final args = routeData.argsAs<FileExplorerScreenRouteArgs>(
          orElse: () => const FileExplorerScreenRouteArgs());
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.FileExplorerScreen(
          key: args.key,
          dummy: args.dummy,
        ),
      );
    },
    PageNotFoundScreenRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.PageNotFoundScreen(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.FileExplorerScreen]
class FileExplorerScreenRoute
    extends _i4.PageRouteInfo<FileExplorerScreenRouteArgs> {
  FileExplorerScreenRoute({
    _i5.Key? key,
    String? dummy,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          FileExplorerScreenRoute.name,
          args: FileExplorerScreenRouteArgs(
            key: key,
            dummy: dummy,
          ),
          initialChildren: children,
        );

  static const String name = 'FileExplorerScreenRoute';

  static const _i4.PageInfo<FileExplorerScreenRouteArgs> page =
      _i4.PageInfo<FileExplorerScreenRouteArgs>(name);
}

class FileExplorerScreenRouteArgs {
  const FileExplorerScreenRouteArgs({
    this.key,
    this.dummy,
  });

  final _i5.Key? key;

  final String? dummy;

  @override
  String toString() {
    return 'FileExplorerScreenRouteArgs{key: $key, dummy: $dummy}';
  }
}

/// generated route for
/// [_i2.PageNotFoundScreen]
class PageNotFoundScreenRoute extends _i4.PageRouteInfo<void> {
  const PageNotFoundScreenRoute({List<_i4.PageRouteInfo>? children})
      : super(
          PageNotFoundScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'PageNotFoundScreenRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SplashScreen]
class SplashScreenRoute extends _i4.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i4.PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}
