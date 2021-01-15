import 'package:flutter/material.dart';
import 'package:squash_archiver/common/l10n/l10n_helpers.dart';
import 'package:squash_archiver/widgets/app_bar/app_bar_title.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class PageNotFoundScreen extends StatelessWidget {
  final String routeName;

  const PageNotFoundScreen(this.routeName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          ln(context, 'pnf_page_title'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: Textography(
                ln(context, 'pnf_body_text'),
                variant: TextVariant.body1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
