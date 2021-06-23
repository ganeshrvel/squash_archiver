import 'package:auto_route/annotations.dart';
import 'package:squash_archiver/common/router/router_auth_guard.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen.dart';
import 'package:squash_archiver/features/page_not_found/ui/pages/page_not_found_screen.dart';
import 'package:squash_archiver/features/splash/ui/pages/splash_screen.dart';

export 'router.gr.dart';

@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    // splash
    AutoRoute(
      path: '/splash',
      page: SplashScreen,
      guards: [
        RouterAuthGuard,
      ],
    ),
    // explorer
    AutoRoute(
      initial: true,
      path: '/fileExplorer',
      page: FileExplorerScreen,
      guards: [
        RouterAuthGuard,
      ],
    ),
    AutoRoute(
      path: '*',
      page: PageNotFoundScreen,
    ),
  ],
)
class $RootRouter {}
