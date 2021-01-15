import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/image_paths.dart';
import 'package:squash_archiver/constants/strings.dart';
import 'package:squash_archiver/widgets/img/img.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class AppLogo extends StatelessWidget {
  final _logoPath = ImagePaths.APP_LOGO;
  final _appName = Strings.APP_NAME.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Img(
          _logoPath,
          height: 35,
        ),
        const SizedBox(width: 7),
        Textography(
          _appName,
          variant: TextVariant.headline3,
        )
      ],
    );
  }
}
