import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as path;
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/helpers/provider_helpers.dart';
import 'package:squash_archiver/features/app/ui/store/app_store.dart';
import 'package:squash_archiver/features/home/data/models/file_explorer_toolbar_entiry.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerToolbarLeading extends StatefulWidget {
  const FileExplorerToolbarLeading({super.key});

  @override
  State<StatefulWidget> createState() => _FileExplorerToolbarLeadingState();
}

class _FileExplorerToolbarLeadingState
    extends SfWidget<FileExplorerToolbarLeading> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  AppStore get _appStore => getIt<AppStore>();

  String _getTitle({required String currentPath}) {
    if (isNullOrEmpty(currentPath)) {
      return '';
    }

    return path.basename(currentPath);
  }

  Widget _buildText({required String text}) {
    return Textography(text);
  }

  Widget _buildIcon(FileExplorerToolbarItemEntity entity) {
    return MacosTooltip(
      message: entity.label,
      useMousePosition: false,
      child: Button(
        type: ButtonType.Icon,
        loading: entity.loading,
        macosIcon: MacosIcon(
          entity.iconData,
          color: MacosTheme.brightnessOf(context).resolve(
            const Color.fromRGBO(0, 0, 0, 0.5),
            const Color.fromRGBO(255, 255, 255, 0.5),
          ),
          size: 20.0,
        ),
        iconButtonBoxConstraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 20,
          maxWidth: 48,
          maxHeight: 38,
        ),
        onPressed: entity.onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final _fileListingInProgress =
            _fileExplorerScreenStore.fileListingInProgress;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(
              (
                label: 'Up',
                iconData: CupertinoIcons.up_arrow,
                loading: _fileListingInProgress,
                onPressed: () {
                  _fileExplorerScreenStore.gotoPrevDirectory();
                },
              ),
            ),
            _buildIcon(
              (
                label: 'Refresh',
                iconData: CupertinoIcons.refresh_circled,
                loading: _fileListingInProgress,
                onPressed: () {
                  _fileExplorerScreenStore.refreshFiles();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
