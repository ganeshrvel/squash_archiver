import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/helpers/navigation_helper.dart';
import 'package:squash_archiver/common/router/app_router.gr.dart';
import 'package:squash_archiver/widget_extends/material.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

@RoutePage(name: 'PageNotFoundScreenRoute')
class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Textography('Page Not Found'),
        titleWidth: 150.0,
        leading: MacosTooltip(
          message: 'Go Back',
          useMousePosition: false,
          child: MacosBackButton(
            onPressed: () {
              navigateToFileExplorerScreen(
                routeArgs: const FileExplorerScreenRouteArgs(),
              );
            },
            fillColor: Colors.transparent,
          ),
        ),
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
                      'Page Not Found - Punintended Detour!',
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
  }
}
