import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/utils/log/log.dart';

/// noted issue: https://github.com/flutter/flutter/issues/20761#issuecomment-493434578
///
/// package_info on iOS requires the Xcode build folder to be rebuilt after changes to the version string in pubspec.yaml. Clean the Xcode build folder with: XCode Menu -> Product -> (Holding Option Key) Clean build folder.

enum OsPlatform {
  macos,
  linux,
  windows,
}

class OS {
  final OsPlatform platform;
  final String releaseName;
  final String? arch;
  final String? deviceId;

  const OS({
    required this.platform,
    required this.releaseName,
    required this.arch,
    required this.deviceId,
  });
}

@LazySingleton()
class DeviceDetails {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceDetails() {
    init();
  }

  Future<OS> get operatingSystem async {
    if (Platform.isMacOS) {
      final info = await _deviceInfoPlugin.macOsInfo;

      return OS(
        platform: OsPlatform.macos,
        releaseName: info.osRelease,
        arch: info.arch,
        deviceId: info.systemGUID,
      );
    }

    if (Platform.isLinux) {
      final info = await _deviceInfoPlugin.linuxInfo;

      return OS(
        platform: OsPlatform.linux,
        releaseName: info.prettyName,
        arch: null,
        deviceId: info.machineId,
      );
    }

    if (Platform.isWindows) {
      final info = await _deviceInfoPlugin.windowsInfo;

      return OS(
        platform: OsPlatform.windows,
        releaseName: info.productName,
        arch: null,
        deviceId: info.deviceId,
      );
    }

    log.error(title: 'operatingSystem', error: 'Unimplemented "platform"');
    throw UnimplementedError('[operatingSystem] Unimplemented "platform"');
  }

  void init() {
    try {
      if (!Platform.isMacOS) {
        throw "Platform isn't supported yet";
      }
    } on PlatformException catch (e, stackTrace) {
      log.error(title: 'DeviceDetails.init', error: e, stackTrace: stackTrace);

      throw 'Platform error';
    }
  }
}
