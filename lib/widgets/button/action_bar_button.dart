import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/widgets/app_tooltip/app_tooltip.dart';
import 'package:squash_archiver/widgets/button/button.dart';

class ActionBarButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final bool loading;
  final bool disabled;
  final double radius;
  final double iconSize;
  final EdgeInsetsGeometry iconPadding;

  const ActionBarButton({
    Key key,
    @required this.text,
    @required this.icon,
    this.loading = false,
    this.disabled = false,
    this.radius = 8,
    this.iconSize = 23,
    this.iconColor,
    this.onPressed,
    this.iconPadding,
  })  : assert(text != null),
        assert(loading != null),
        assert(disabled != null),
        assert(iconSize != null),
        assert(radius != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _iconColor = iconColor ?? AppColors.color797;
    final _iconPadding = iconPadding ?? const EdgeInsets.all(5);

    return AppTooltip(
      message: text,
      child: Button(
        text: text,
        onPressed: onPressed,
        buttonType: ButtonType.ICON,
        icon: icon,
        iconColor: _iconColor,
        iconButtonPadding: _iconPadding,
        iconButtonIconSize: iconSize,
        loading: loading,
        radius: radius,
        disabled: disabled,
        disableAutoBoxConstraints: true,
      ),
    );
  }
}
