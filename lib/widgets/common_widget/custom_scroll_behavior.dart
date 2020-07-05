import 'package:flutter/material.dart';

class CustomScrollBehavior extends StatelessWidget {
  final Widget child;

  const CustomScrollBehavior({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: Colors.purple,
      child: child,
    );
  }
}
