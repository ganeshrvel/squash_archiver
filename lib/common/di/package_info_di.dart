import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';

@module
abstract class PackageInfoDi {
  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}
