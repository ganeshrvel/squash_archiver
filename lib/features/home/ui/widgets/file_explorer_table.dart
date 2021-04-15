import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart' show ReactionDisposer, reaction;
import 'package:squash_archiver/common/helpers/provider_helpers.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_keyboard_modifiers_store.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table_row_tile.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

class FileExplorerTable extends StatefulWidget {
  const FileExplorerTable({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FileExplorerTableState();
}

class _FileExplorerTableState extends SfWidget<FileExplorerTable> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  FileExplorerKeyboardModifiersStore get _fileExplorerKeyboardModifiersStore =>
      readProvider<FileExplorerKeyboardModifiersStore>(context);

  List<ReactionDisposer>? _disposers;

  @override
  void didChangeDependencies() {
    _disposers ??= [
      reaction(
        (_) => _fileExplorerKeyboardModifiersStore.isSelectAllPressed,
        (bool isSelectAllPressed) {
          if (isNull(isSelectAllPressed)) {
            return;
          }

          if (isSelectAllPressed) {
            _fileExplorerScreenStore.selectAllFiles();
          }
        },
      ),
    ];

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    disposeStore(_disposers);

    super.dispose();
  }

  Widget _buildRow({
    required FileListingResponse fileContainer,
    required int index,
  }) {
    return FileExplorerTableRow(
      fileContainer: fileContainer,
      rowIndex: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final _files = _fileExplorerScreenStore.fileContainers;
      final _rowsLength = _files.length;

      return SliverList(
        delegate: SliverChildBuilderDelegate((
          BuildContext context,
          int index,
        ) {
          if (index >= _rowsLength) {
            return null;
          }

          final _fileContainer = _files[index];

          return _buildRow(
            fileContainer: _fileContainer,
            index: index,
          );
        }),
      );
    });
  }
}
