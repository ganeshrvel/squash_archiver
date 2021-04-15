import 'package:auto_route/auto_route.dart';

class RouterAuthGuard extends AutoRouteGuard {
  @override
  Future<bool> canNavigate(
    List<PageRouteInfo> pendingRoutes,
    StackRouter router,
  ) async {
    return true;
  }
}
