import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';

class PullDownToRefresh extends StatelessWidget {
  final Widget child;

  final RefreshCallback onRefresh;

  const PullDownToRefresh({
    Key key,
    this.child,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _palette = getPalette(context);

    return RefreshIndicator(
      color: _palette.accentColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
