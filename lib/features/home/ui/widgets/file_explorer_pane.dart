import 'package:flutter/material.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

class FileExplorerPane extends StatefulWidget {
  final FileExplorerScreenStore fileExplorerScreenStore;

  const FileExplorerPane({
    Key key,
    @required this.fileExplorerScreenStore,
  })  : assert(fileExplorerScreenStore != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FileExplorerPaneState();
}

class _FileExplorerPaneState extends SfWidget<FileExplorerPane> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.zero,
      sliver: FileExplorerTable(
        fileExplorerScreenStore: _fileExplorerScreenStore,
      ),
    );
  }
}
