import 'package:url_launcher/url_launcher.dart';

class IntentUrls {
  void launchUrl(String url) {
    launch(url);
  }

  Future<void> launchIntent(String url) async {
    final _canLaunch = canLaunch(url);

    if (!await _canLaunch) {
      return;
    }

    launchUrl(url);
  }
}
