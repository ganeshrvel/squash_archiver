import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/shadows/box_shadow_1.dart';

class FileExplorerToolbar extends StatefulWidget {
  final FileExplorerScreenStore fileExplorerScreenStore;

  const FileExplorerToolbar({
    Key key,
    @required this.fileExplorerScreenStore,
  })  : assert(fileExplorerScreenStore != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => FileExplorerToolbarState();
}

class FileExplorerToolbarState extends SfWidget<FileExplorerToolbar> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow5(),
        ],
      ),
      padding: EdgeInsets.zero,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Observer(
              builder: (_) {
                final _listFilesInProgress =
                    _fileExplorerScreenStore.fileListingInProgress;

                return Button(
                  text: 'Back',
                  onPressed: () {
                    _fileExplorerScreenStore.gotoPrevDirectory();
                  },
                  buttonType: ButtonType.ICON,
                  icon: Icons.arrow_back,
                  iconButtonPadding: const EdgeInsets.all(20),
                  loading: _listFilesInProgress,
                );
              },
            ),
            Observer(
              builder: (_) {
                final _listFilesInProgress =
                    _fileExplorerScreenStore.fileListingInProgress;

                return Button(
                  text: 'Refresh',
                  onPressed: () {
                    _fileExplorerScreenStore.refreshFiles();
                  },
                  buttonType: ButtonType.ICON,
                  icon: Icons.refresh,
                  iconButtonPadding: const EdgeInsets.all(20),
                  loading: _listFilesInProgress,
                );
              },
            ),
            Observer(
              builder: (_) {
                final _listFilesInProgress =
                    _fileExplorerScreenStore.fileListingInProgress;

                return Button(
                  text: 'Force refresh',
                  onPressed: () {
                    _fileExplorerScreenStore.refreshFiles(
                      invalidateCache: true,
                    );
                  },
                  buttonType: ButtonType.ICON,
                  icon: Icons.replay_circle_filled,
                  iconButtonPadding: const EdgeInsets.all(20),
                  loading: _listFilesInProgress,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
