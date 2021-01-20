import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart' show ReactionDisposer, reaction;
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table_row_tile.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

class FileExplorerTable extends StatefulWidget {
  final FileExplorerScreenStore fileExplorerScreenStore;

  const FileExplorerTable({
    Key key,
    @required this.fileExplorerScreenStore,
  })  : assert(fileExplorerScreenStore != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FileExplorerTableState();
}

class _FileExplorerTableState extends SfWidget<FileExplorerTable> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  List<ReactionDisposer> _disposers;

  @override
  void didChangeDependencies() {
    _disposers ??= [
      reaction(
        (_) => _fileExplorerScreenStore.isSelectAllPressed,
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
    @required FileListingResponse fileContainer,
    @required int index,
  }) {
    assert(fileContainer != null);
    assert(index != null);

    return FileExplorerTableRow(
      fileContainer: fileContainer,
      rowIndex: index,
      fileExplorerScreenStore: _fileExplorerScreenStore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final _files = _fileExplorerScreenStore.files;
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
