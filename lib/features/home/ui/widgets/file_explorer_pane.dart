import 'package:flutter/material.dart';
import 'package:squash_archiver/common/helpers/provider_helpers.dart';
import 'package:squash_archiver/constants/sizes.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

class FileExplorerPane extends StatefulWidget {
  const FileExplorerPane({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FileExplorerPaneState();
}

class _FileExplorerPaneState extends SfWidget<FileExplorerPane> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.FILE_EXPLORER_HORZ_PADDING,
        vertical: 5,
      ),
      sliver: FileExplorerTable(),
    );
  }
}
