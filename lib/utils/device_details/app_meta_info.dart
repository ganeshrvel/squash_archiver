import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';

@lazySingleton
class AppMetaInfo {
  late PackageInfo _packageInfo;

  AppMetaInfo();

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  // this is the build number of the app
  int get appVersionCode {
    return int.parse(_packageInfo.buildNumber);
  }

  // this is the app version
  String get appVersion {
    return _packageInfo.version;
  }

  String get release {
    return '${appVersion}+${appVersionCode}';
  }
}
