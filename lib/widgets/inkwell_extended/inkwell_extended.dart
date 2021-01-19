import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class InkWellExtended extends StatelessWidget {
  ///
  /// Replacing the working of the default [onDoubleTap] implementation
  /// using [onTap]
  ///
  InkWellExtended({
    Key key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.doubleTapTime = const Duration(milliseconds: 300),
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.splashFactory,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.autofocus = false,
    this.mouseCursor,
    this.overlayColor,
  })  : assert(enableFeedback != null),
        assert(excludeFromSemantics != null),
        assert(doubleTapTime != null),
        assert(autofocus != null),
        assert(canRequestFocus != null),
        super(key: key);

  final Widget child;
  final GestureTapCallback onTap;
  final GestureTapCallback onDoubleTap;
  final Duration doubleTapTime;
  final GestureLongPressCallback onLongPress;
  final GestureTapDownCallback onTapDown;
  final GestureTapCancelCallback onTapCancel;
  final ValueChanged<bool> onHighlightChanged;
  final ValueChanged<bool> onHover;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final InteractiveInkFeatureFactory splashFactory;
  final double radius;
  final BorderRadius borderRadius;
  final ShapeBorder customBorder;
  final bool enableFeedback;
  final bool excludeFromSemantics;
  final FocusNode focusNode;
  final bool canRequestFocus;
  final ValueChanged<bool> onFocusChange;
  final bool autofocus;
  final MouseCursor mouseCursor;
  final MaterialStateProperty<Color> overlayColor;

  DateTime _lastTapTime;

  /// replace default [onDoubleTap] implementation with the help of [onTap]
  void _onTap() {
    final _now = DateTime.now();

    if (_lastTapTime != null) {
      /// if the difference between current timestamp [_now] and [_lastTapTime]
      /// is less than [doubleTapTime] then register it as [onDoubleTap]
      if (_now.difference(_lastTapTime).inMilliseconds <
          doubleTapTime.inMilliseconds) {
        if (onDoubleTap != null) {
          onDoubleTap();

          return;
        }
      }
    }

    if (onTap != null) {
      onTap();
    }

    _lastTapTime = _now;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      onTap: (onDoubleTap != null) ? _onTap : onTap,
      // if onDoubleTap is not used from user, then route further to onTap
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      onHighlightChanged: onHighlightChanged,
      onHover: onHover,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      mouseCursor: mouseCursor,
      overlayColor: overlayColor,
      child: child,
    );
  }
}
