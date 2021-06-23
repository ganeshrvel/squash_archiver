import 'package:squash_archiver/common/router/router.dart';
import 'package:squash_archiver/common/router/router_auth_guard.dart';

final rootRouter = RootRouter(
  routerAuthGuard: RouterAuthGuard(),
);
