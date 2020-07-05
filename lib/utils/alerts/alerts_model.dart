import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

enum AlertsTypes {
  ERROR,
  WARNING,
  INFO,
  SUCCESS,
}

enum AlertsPopupTypes {
  FLUSHBAR,
  WIDGET,
}

class AlertsModel {
  final String body;
  final String title;
  final AlertsTypes type;
  final AlertsPopupTypes popupType;
  final BuildContext context;

  final int generatedTime = DateTime.now().microsecondsSinceEpoch;
  Duration duration;

  AlertsModel({
    @required this.context,
    @required this.body,
    @required this.title,
    @required this.popupType,
    @required this.type,
    this.duration,
  }) {
    setDuration(duration);
  }

  void setDuration(Duration _duration) {
    duration = _duration ?? const Duration(seconds: 3);
  }
}
