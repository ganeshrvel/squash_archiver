import 'dart:async';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:squash_archiver/utils/log/log.dart';
import 'package:injectable/injectable.dart';

/// noted issue: https://github.com/flutter/flutter/issues/20761#issuecomment-493434578
///
/// package_info on iOS requires the Xcode build folder to be rebuilt after changes to the version string in pubspec.yaml. Clean the Xcode build folder with: XCode Menu -> Product -> (Holding Option Key) Clean build folder.

@lazySingleton
class DeviceDetails {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceDetails() {
    init();
  }

  Future<String> get deviceId async {
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;

      return info.androidId;
    }

    final info = await _deviceInfoPlugin.iosInfo;

    return info.identifierForVendor;
  }

  String get osType {
    return Platform.operatingSystem.toUpperCase();
  }

  Future<String> get osVersion async {
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;

      return info.version.release;
    }

    final info = await _deviceInfoPlugin.iosInfo;

    return info.systemVersion;
  }

  Future<int> get sdkVersion async {
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;

      return info.version.sdkInt;
    }

    return 0;
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
