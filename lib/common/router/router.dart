import 'package:auto_route/annotations.dart';
import 'package:squash_archiver/common/router/router_auth_guard.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen.dart';
import 'package:squash_archiver/features/page_not_found/ui/pages/page_not_found_screen.dart';
import 'package:squash_archiver/features/splash/ui/pages/splash_screen.dart';

@AdaptiveAutoRouter(routes: [
  AdaptiveRoute(
    page: SplashScreen,
    guards: [
      RouterAuthGuard,
    ],
  ),
  AdaptiveRoute(
    page: FileExplorerScreen,
    initial: true,
    guards: [
      RouterAuthGuard,
    ],
  ),
  AdaptiveRoute(path: '*', page: PageNotFoundScreen),
])
class $AppRouter {}
