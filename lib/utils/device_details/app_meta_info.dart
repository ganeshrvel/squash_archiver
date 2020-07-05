import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';

@lazySingleton
class AppMetaInfo {
  final PackageInfo _packageInfo;

  AppMetaInfo(this._packageInfo);

  // this is the build number of the app
  int get appVersionCode {
    return int.parse(_packageInfo.buildNumber);
  }

  // this is the app version
  String get appVersion {
    return _packageInfo.version;
  }
}
