import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/router/router.gr.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

bool isCurrentScreen(BuildContext context) {
  return ModalRoute.of(context).isCurrent;
}

String getCurrentScreen(BuildContext context) {
  if (isNull(context)) {
    return null;
  }

  return ModalRoute.of(context).settings.name;
}

void navigateToRoute(
  BuildContext context,
  String routeName, {
  Object routeArgs,
}) {
  if (getCurrentScreen(context) == routeName) {
    return;
  }

  if (routeName == Routes.homeScreen) {
    navigateToHome(context, routeArgs: HomeScreenArguments());

    return;
  }

  if (routeArgs != null) {
    ExtendedNavigator.of(context).pushNamed(
      routeName,
      arguments: routeArgs,
    );

    return;
  }

  ExtendedNavigator.of(context).pushNamed(routeName);
}

void navigateToRouteAndReplace(
  BuildContext context,
  String routeName, {
  Object routeArgs,
}) {
  if (routeName == Routes.homeScreen) {
    navigateToHome(context, routeArgs: HomeScreenArguments());

    return;
  }

  if (routeArgs != null) {
    ExtendedNavigator.of(context).pushReplacementNamed(
      routeName,
      arguments: routeArgs,
    );

    return;
  }

  ExtendedNavigator.of(context).pushReplacementNamed(
    routeName,
  );
}

void navigateToRouteAndRemoveUntil(
  BuildContext context,
  String routeName, {
  Object routeArgs,
}) {
  if (routeArgs != null) {
    ExtendedNavigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (final route) => false,
      arguments: routeArgs,
    );

    return;
  }

  ExtendedNavigator.of(context).pushNamedAndRemoveUntil(
    routeName,
    (final route) => false,
  );
}

void popCurrentRoute(BuildContext context) {
  ExtendedNavigator.of(context).pop();
}

void canPopCurrentRoute(BuildContext context) {
  ExtendedNavigator.of(context).canPop();
}

void navigateToHome(
  BuildContext context, {
  @required HomeScreenArguments routeArgs,
}) {
  navigateToRouteAndRemoveUntil(
    context,
    Routes.homeScreen,
    routeArgs: routeArgs,
  );
}
