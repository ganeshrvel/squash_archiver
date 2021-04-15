import 'package:flutter/material.dart';

class AppBarTextAction extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;

  const AppBarTextAction({
    Key? key,
    this.child,
    this.padding = const EdgeInsets.fromLTRB(0, 0, 20, 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: child,
      ),
    );
  }
}
