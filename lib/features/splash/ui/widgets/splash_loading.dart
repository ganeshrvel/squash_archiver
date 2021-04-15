import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:squash_archiver/widgets/img/img.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class SplashLoading extends StatelessWidget {
  final String logoPath;
  final String appName;

  const SplashLoading({
    required this.logoPath,
    required this.appName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Img(
            logoPath,
            height: 100,
          ),
          const SizedBox(height: 24),
          Textography(
            appName,
            variant: TextVariant.headline3,
          )
        ],
      ),
    );
  }
}
