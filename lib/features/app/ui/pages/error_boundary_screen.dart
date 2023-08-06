import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

void setErrorBuilder() {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Textography('Unrecoverable Crash Occured'),
        titleWidth: 150.0,
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Textography(
                      'Apologies for the error. Restart the app. If issue persists, contact: ganeshrvel@outlook.com',
                      variant: TextVariant.Body,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  };
}
