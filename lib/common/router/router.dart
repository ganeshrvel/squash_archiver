import 'package:auto_route/annotations.dart';
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
    ),
    // explorer
    AutoRoute(
      initial: true,
      path: '/fileExplorer',
      page: FileExplorerScreen,
    ),
    AutoRoute(
      path: '*',
      page: PageNotFoundScreen,
    ),
  ],
)
class $RootRouter {}
