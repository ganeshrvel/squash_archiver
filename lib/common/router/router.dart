import 'package:auto_route/auto_route_annotations.dart';
import 'package:squash_archiver/features/home/ui/pages/home_screen.dart';
import 'package:squash_archiver/features/page_not_found/ui/pages/page_not_found_screen.dart';
import 'package:squash_archiver/features/splash/ui/pages/splash_screen.dart';

@CustomAutoRouter()
class $Router {
  SplashScreen splashScreen;

  @CustomRoute(
    initial: true,
  )
  HomeScreen homeScreen;

  @unknownRoute
  PageNotFoundScreen pageNotFoundScreen;
}
