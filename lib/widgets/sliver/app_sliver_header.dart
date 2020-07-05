import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';

class AppSliverHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  final double maximumExtent;

  final double minimumExtent;

  final Color backgroundColor;

  AppSliverHeader({
    @required this.child,
    @required this.maximumExtent,
    @required this.minimumExtent,
    this.backgroundColor = AppColors.white,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: backgroundColor,
          height: constraints.maxHeight,
          child: child,
        );
      },
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => maximumExtent;

  @override
  double get minExtent => minimumExtent;
}
