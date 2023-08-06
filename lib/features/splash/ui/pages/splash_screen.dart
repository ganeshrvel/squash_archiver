import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/helpers/navigation_helper.dart';
import 'package:squash_archiver/common/router/app_router.gr.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends SfWidget<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> onInitApp() async {
    navigateToFileExplorerScreen(
      routeArgs: const FileExplorerScreenRouteArgs(),
    );

    return super.onInitApp();
  }

  Widget _buildSplashScreen(BuildContext context) {
    return const ProgressCircle();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return Center(child: _buildSplashScreen(context));
          },
        ),
      ],
    );
  }
}
