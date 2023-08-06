import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/router/app_router.gr.dart';

@LazySingleton()
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/splash',
          page: SplashScreenRoute.page,
        ),
        AutoRoute(
          initial: true,
          path: '/fileExplorer',
          page: FileExplorerScreenRoute.page,
        ),
        AutoRoute(
          path: '*',
          page: PageNotFoundScreenRoute.page,
        ),
      ];
}
