import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/shadows/box_shadow_3.dart';

class AppTooltip extends StatelessWidget {
  const AppTooltip({
    Key key,
    @required this.message,
    this.padding,
    this.child,
    this.waitDuration,
    this.showDuration,
  }) : super(key: key);

  /// The text to display in the tooltip.
  final String message;

  /// The amount of space by which to inset the tooltip's [child].
  ///
  /// Defaults to 16.0 logical pixels in each direction.
  final EdgeInsetsGeometry padding;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The length of time that a pointer must hover over a tooltip's widget
  /// before the tooltip will be shown.
  ///
  /// Once the pointer leaves the widget, the tooltip will immediately
  /// disappear.
  ///
  final Duration waitDuration;

  /// The length of time that the tooltip will be shown after a long press
  /// is released.
  ///
  final Duration showDuration;

  @override
  Widget build(BuildContext context) {
    /// don't show empty popup
    if (isNullOrEmpty(message)) {
      return child;
    }

    final _palette = getPalette(context);

    return Tooltip(
      waitDuration: waitDuration ?? const Duration(milliseconds: 700),
      showDuration: showDuration,
      message: message,
      decoration: BoxDecoration(
        color: _palette.tooltipColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow3(),
        ],
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 1, horizontal: 7),
      textStyle: TextStyle(
        color: _palette.tooltipTextColor,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
      child: child,
    );
  }
}
