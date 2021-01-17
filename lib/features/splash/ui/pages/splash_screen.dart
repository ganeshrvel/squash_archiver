import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/image_paths.dart';
import 'package:squash_archiver/constants/strings.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/features/splash/ui/widgets/splash_loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends SfWidget<SplashScreen> {
  @override
  void initState() {
    init();

    super.initState();
  }

  void init() {
    BackButtonInterceptor.add(_handleBackButtonInterceptor);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> onInitApp() async {
    return super.onInitApp();
  }

  bool _handleBackButtonInterceptor(
    bool stopDefaultButtonEvent,
    RouteInfo routeInfo,
  ) {
    // allow back button
    return false;
  }

  Widget _buildSplashScreen(BuildContext context) {
    return SplashLoading(
      logoPath: ImagePaths.APP_LOGO,
      appName: Strings.APP_NAME.toUpperCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSplashScreen(context),
    );
  }
}
