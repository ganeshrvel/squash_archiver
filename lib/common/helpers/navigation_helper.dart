import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/router/router.gr.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

bool isCurrentScreen(BuildContext context) {
  if (isNull(context)) {
    return null;
  }

  return ModalRoute.of(context).isCurrent;
}

String getCurrentScreen(BuildContext context) {
  if (isNull(context)) {
    return null;
  }

  return ModalRoute.of(context).settings.name;
}

Future<T> navigateToRoute<T>(
  BuildContext context,
  String routeName, {
  Object routeArgs,
  bool skipSameRouteCheck,
}) async {
  final _skipSameRouteCheck = skipSameRouteCheck ?? true;

  if (!_skipSameRouteCheck && getCurrentScreen(context) == routeName) {
    return null;
  }

  if (routeName == Routes.fileExplorerScreen) {
    var _routeArgs = FileExplorerScreenArguments();

    if (routeArgs is FileExplorerScreenArguments) {
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

Future<T> navigateToRouteAndReplace<T>(
  String routeName, {
  Object routeArgs,
}) async {
  if (routeName == Routes.fileExplorerScreen) {
    var _routeArgs = FileExplorerScreenArguments();

    if (routeArgs is FileExplorerScreenArguments) {
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

Future<T> navigateToRouteAndRemoveUntil<T>(
  String routeName, {
  Object routeArgs,
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

void popCurrentRoute<T>({T result}) {
  return ExtendedNavigator?.root?.pop<T>(result);
}

bool canPopCurrentRoute<T>() {
  return ExtendedNavigator?.root?.canPop();
}

Future<T> navigateToFileExplorerScreen<T>({
  @required FileExplorerScreenArguments routeArgs,
}) async {
  return navigateToRouteAndRemoveUntil<T>(
    Routes.fileExplorerScreen,
    routeArgs: routeArgs,
  );
}
