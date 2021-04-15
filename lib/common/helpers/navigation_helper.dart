import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
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
  String routeName, {
  Object? routeArgs,
  bool? skipSameRouteCheck,
}) async {
  final _skipSameRouteCheck = skipSameRouteCheck ?? true;

  if (!_skipSameRouteCheck && getCurrentScreen(context) == routeName) {
    return null;
  }

  if (routeName == FileExplorerScreenRoute.name) {
    var _routeArgs = const FileExplorerScreenRouteArgs();

    if (routeArgs is FileExplorerScreenRouteArgs) {
      _routeArgs = routeArgs;
    }

    return navigateToFileExplorerScreen<T>(routeArgs: _routeArgs);
  }

  if (routeArgs != null) {
    return ExtendedNavigator?.root?.push<T>(
      routeName,
      arguments: routeArgs,
    );
  }
  return ExtendedNavigator?.root?.push<T>(routeName);
}

Future<T?> navigateToRouteAndReplace<T extends Object>(
  String routeName, {
  Object? routeArgs,
}) async {
  if (routeName == FileExplorerScreenRoute.name) {
    var _routeArgs = const FileExplorerScreenRouteArgs();

    if (routeArgs is FileExplorerScreenRouteArgs) {
      _routeArgs = routeArgs;
    }

    return navigateToFileExplorerScreen<T>(routeArgs: _routeArgs);
  }

  if (routeArgs != null) {
    return ExtendedNavigator?.root?.replace(
      routeName,
      arguments: routeArgs,
    );
  }

  return ExtendedNavigator?.root?.replace(
    routeName,
  );
}

Future<T?> navigateToRouteAndRemoveUntil<T extends Object>(
  String routeName, {
  Object? routeArgs,
}) async {
  if (routeArgs != null) {
    return ExtendedNavigator?.root?.pushAndRemoveUntil<T>(
      routeName,
      (final route) => false,
      arguments: routeArgs,
    );
  }

  return ExtendedNavigator?.root?.pushAndRemoveUntil<T>(
    routeName,
    (final route) => false,
  );
}

void popCurrentRoute<T extends Object>({T? result}) {
  return ExtendedNavigator?.root?.pop<T>(result);
}

bool canPopCurrentRoute<T>() {
  return ExtendedNavigator?.root?.canPop() ?? false;
}

Future<T?> navigateToFileExplorerScreen<T extends Object>({
  required FileExplorerScreenRouteArgs routeArgs,
}) async {
  return navigateToRouteAndRemoveUntil<T>(
    FileExplorerScreenRoute.name,
    routeArgs: routeArgs,
  );
}
