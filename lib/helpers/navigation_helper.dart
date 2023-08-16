import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/router/app_router.gr.dart';
import 'package:squash_archiver/common/router/root_router.dart';

bool? isCurrentScreen(BuildContext? context) {
  if (context == null) {
    return null;
  }

  return ModalRoute.of(context)!.isCurrent;
}

// todo
String? getCurrentScreen(BuildContext? context) {
  if (context == null) {
    return null;
  }

  return ModalRoute.of(context)!.settings.name;
}

Future<T?> navigateToRoute<T extends dynamic>(
  BuildContext? context,
  PageRouteInfo route, {
  bool? skipSameRouteCheck,
}) async {
  final _skipSameRouteCheck = skipSameRouteCheck ?? true;

  if (!_skipSameRouteCheck && getCurrentScreen(context) == route.routeName) {
    return null;
  }

  if (route.routeName == FileExplorerScreenRoute.name) {
    var _routeArgs = const FileExplorerScreenRouteArgs();

    if (route.args is FileExplorerScreenRouteArgs) {
      _routeArgs = route.args as FileExplorerScreenRouteArgs;
    }

    return navigateToFileExplorerScreen<T>(routeArgs: _routeArgs);
  }

  return rootRouter.push(route);
}

Future<T?> navigateToRouteAndReplace<T extends dynamic>(
  PageRouteInfo route,
) async {
  if (route.routeName == FileExplorerScreenRoute.name) {
    var _routeArgs = const FileExplorerScreenRouteArgs();

    if (route.args is FileExplorerScreenRouteArgs) {
      _routeArgs = route.args as FileExplorerScreenRouteArgs;
    }

    return navigateToFileExplorerScreen<T>(routeArgs: _routeArgs);
  }

  return rootRouter.replace(
    route,
  );
}

Future<T?> navigateToRouteAndRemoveUntil<T extends dynamic>(
  PageRouteInfo route,
) async {
  return rootRouter.pushAndPopUntil<T>(
    route,
    predicate: (r) => false,
  );
}

Future<bool> popCurrentRoute<T extends dynamic>({T? result}) async {
  return rootRouter.pop<T>(result);
}

Future<T?> navigateToFileExplorerScreen<T extends dynamic>({
  required FileExplorerScreenRouteArgs routeArgs,
}) async {
  return navigateToRouteAndRemoveUntil<T>(
    FileExplorerScreenRoute(
      dummy: routeArgs.dummy,
    ),
  );
}
