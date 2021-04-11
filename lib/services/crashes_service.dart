import 'package:flutter/widgets.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry/sentry.dart';
import 'package:squash_archiver/utils/device_details/app_meta_info.dart';
import 'package:squash_archiver/utils/device_details/device_details.dart';
import 'package:squash_archiver/utils/utils/error.dart';

@lazySingleton
class CrashesService {
  final DeviceDetails _deviceDetails;

  CrashesService(
    this._deviceDetails,
  );

  void capture({
    @required String title,
    @required dynamic error,
    @required StackTrace stackTrace,
    @required StackTrace fullStackTrace,
    BuildContext context,
    Map<String, String> extras,
  }) {
    if (!env.config.reportCrashAnalytics) {
      return;
    }

    Sentry.configureScope((scope) async {
      scope.setTag('deviceId', await _deviceDetails.deviceId);
      // ..setTag('app.version', _appMetaInfo.release);
    });

    Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );

    // FirebaseCrashlytics.instance.recordError(
    //   error,
    //   stackTrace,
    // );
  }
}
