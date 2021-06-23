import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/router/root_router.dart';
import 'package:squash_archiver/common/router/router.gr.dart';

bool? isCurrentScreen(BuildContext? context) {
  if (context == null) {
    return null;
  }

  return ModalRoute.of(context)!.isCurrent;
}

String? getCurrentScreen(BuildContext? context) {
  if (context == null) {
    return null;
  }

  return ModalRoute.of(context)!.settings.name;
}

Future<T?> navigateToRoute<T extends Object>(
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

Future<T?> navigateToRouteAndReplace<T extends Object>(
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

Future<T?> navigateToRouteAndRemoveUntil<T extends Object>(
  PageRouteInfo route,
) async {
  return rootRouter.pushAndPopUntil<T>(
    route,
    predicate: (r) => false,
  );
}

Future<bool> popCurrentRoute<T extends Object>({T? result}) async {
  return rootRouter.pop<T>(result);
}

bool canPopCurrentRoute<T>() {
  return rootRouter.canPopSelfOrChildren;
}

Future<T?> navigateToFileExplorerScreen<T extends Object>({
  required FileExplorerScreenRouteArgs routeArgs,
}) async {
  return navigateToRouteAndRemoveUntil<T>(
    FileExplorerScreenRoute(
      dummy: routeArgs.dummy,
    ),
  );
}
