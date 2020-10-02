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

    return navigateToFileExplorerScreen<T>(context, routeArgs: _routeArgs);
  }

  if (routeArgs != null) {
    return ExtendedNavigator?.rootNavigator?.pushNamed<T>(
      routeName,
      arguments: routeArgs,
    );
  }
  return ExtendedNavigator?.rootNavigator?.pushNamed<T>(routeName);
}

Future<T> navigateToRouteAndReplace<T>(
  BuildContext context,
  String routeName, {
  Object routeArgs,
}) async {
  if (routeName == Routes.fileExplorerScreen) {
    var _routeArgs = FileExplorerScreenArguments();

    if (routeArgs is FileExplorerScreenArguments) {
      _routeArgs = routeArgs;
    }

    return navigateToFileExplorerScreen<T>(context, routeArgs: _routeArgs);
  }

  if (routeArgs != null) {
    return ExtendedNavigator?.rootNavigator?.pushReplacementNamed(
      routeName,
      arguments: routeArgs,
    );
  }

  return ExtendedNavigator?.rootNavigator?.pushReplacementNamed(
    routeName,
  );
}

Future<T> navigateToRouteAndRemoveUntil<T>(
  BuildContext context,
  String routeName, {
  Object routeArgs,
}) async {
  if (routeArgs != null) {
    return ExtendedNavigator?.rootNavigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      (final route) => false,
      arguments: routeArgs,
    );
  }

  return ExtendedNavigator?.rootNavigator?.pushNamedAndRemoveUntil<T>(
    routeName,
    (final route) => false,
  );
}

void popCurrentRoute<T>(
  BuildContext context, {
  T result,
}) {
  return ExtendedNavigator?.rootNavigator?.pop<T>(result);
}

bool canPopCurrentRoute<T>(BuildContext context) {
  return ExtendedNavigator?.rootNavigator?.canPop();
}

Future<T> pushRoute<T>(BuildContext context, Route route) async {
  return ExtendedNavigator?.rootNavigator?.push<dynamic>(route) as Future<T>;
}

Future<T> navigateToFileExplorerScreen<T>(
  BuildContext context, {
  @required FileExplorerScreenArguments routeArgs,
}) async {
  return navigateToRouteAndRemoveUntil<T>(
    context,
    Routes.fileExplorerScreen,
    routeArgs: routeArgs,
  );
}
