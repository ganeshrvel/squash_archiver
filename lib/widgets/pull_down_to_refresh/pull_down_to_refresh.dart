import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/colors.dart';

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
    return RefreshIndicator(
      color: AppColors.blue,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
