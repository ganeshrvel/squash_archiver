import 'package:flutter/material.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class AppBarTitle extends StatelessWidget {
  final String text;

  const AppBarTitle(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Textography(
      text,
      variant: TextVariant.headline6,
      fontWeight: FontWeight.normal,
    );
  }
}
