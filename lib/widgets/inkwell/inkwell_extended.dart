import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/inkwell/cupertino_inkwell.dart';

/// [onDoubleTap] delays the [onTap] event. This is because the InkWellExtended waits
/// for a few milliseconds before [onTap] event is executed.
/// To overcome this problem we custom implement [onDoubleTap] using [onTap] logic
/// [doubleTapTime] is used to initiate [onDoubleTap]

class InkWellExtended extends StatefulWidget {
  final Duration doubleTapTime;
  final bool allowPassthroughSingleTapBeforeDoubleTap;
  final Widget? child;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTap;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapCallback? onDoubleTap;
  final bool excludeFromSemantics;

  const InkWellExtended({
    super.key,
    this.doubleTapTime = const Duration(milliseconds: 300),
    this.allowPassthroughSingleTapBeforeDoubleTap = true,
    this.child,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
    this.onDoubleTap,
    this.excludeFromSemantics = false,
  });

  @override
  _InkWellExtendedState createState() => _InkWellExtendedState();
}

class _InkWellExtendedState extends SfWidget<InkWellExtended> {
  // Getters following the specified pattern.
  Duration get doubleTapTime => widget.doubleTapTime;

  bool get allowPassthroughSingleTapBeforeDoubleTap =>
      widget.allowPassthroughSingleTapBeforeDoubleTap;

  Widget? get child => widget.child;

  GestureTapDownCallback? get onTapDown => widget.onTapDown;

  GestureTapUpCallback? get onTapUp => widget.onTapUp;

  GestureTapCallback? get onTap => widget.onTap;

  GestureTapCancelCallback? get onTapCancel => widget.onTapCancel;

  GestureTapCallback? get onDoubleTap => widget.onDoubleTap;

  bool get excludeFromSemantics => widget.excludeFromSemantics;

  DateTime? _lastTapTime;

  /// replace default [onDoubleTap] implementation with the help of [onTap]
  void _onTap() {
    if (allowPassthroughSingleTapBeforeDoubleTap) {
      if (onTap != null) {
        onTap?.call();
      }
    }

    final _now = DateTime.now();

    if (_lastTapTime != null) {
      /// if the difference between current timestamp [_now] and [_lastTapTime]
      /// is less than [doubleTapTime] then register it as [onDoubleTap]
      if (_now.difference(_lastTapTime!).inMilliseconds <
          doubleTapTime.inMilliseconds) {
        if (onDoubleTap != null) {
          onDoubleTap!();

          return;
        }
      }
    }

    _lastTapTime = _now;

    if (!allowPassthroughSingleTapBeforeDoubleTap) {
      if (onTap != null) {
        onTap?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoInkWell(
      key: widget.key,
      onTap: (onDoubleTap != null) ? _onTap : onTap,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      excludeFromSemantics: excludeFromSemantics,
      focusColor: MacosColors.transparent,
      hoverColor: MacosColors.transparent,
      onFocusChange: null,
      onHighlightChanged: null,
      pressColor: MacosColors.transparent,
      child: child,
    );
  }
}
