import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/common/helpers/provider_helpers.dart';
import 'package:squash_archiver/common/themes/colors.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/action_bar_button.dart';

class FileExplorerToolbar extends StatefulWidget {
  const FileExplorerToolbar({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FileExplorerToolbarState();
}

class FileExplorerToolbarState extends SfWidget<FileExplorerToolbar> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Observer(
        builder: (_) {
          final _listFilesInProgress =
              _fileExplorerScreenStore.fileListingInProgress;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ActionBarButton(
                  text: 'Back',
                  onPressed: () {
                    _fileExplorerScreenStore.gotoPrevDirectory();
                  },
                  icon: CupertinoIcons.back,
                  loading: _listFilesInProgress,
                  iconSize: 23,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ActionBarButton(
                  text: 'Refresh',
                  onPressed: () {
                    _fileExplorerScreenStore.refreshFiles();
                  },
                  icon: CupertinoIcons.refresh_circled,
                  loading: _listFilesInProgress,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
