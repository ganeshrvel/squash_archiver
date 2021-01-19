import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table_row.dart';
import 'package:squash_archiver/widgets/inkwell_extended/inkwell_extended.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerTableRow extends StatefulWidget {
  final FileExplorerScreenStore fileExplorerScreenStore;

  final int rowIndex;

  final FileListingResponse fileContainer;

  const FileExplorerTableRow({
    Key key,
    @required this.fileExplorerScreenStore,
    @required this.fileContainer,
    @required this.rowIndex,
  })  : assert(fileExplorerScreenStore != null),
        assert(rowIndex != null),
        super(key: key);

  @override
  _FileExplorerTableRowState createState() => _FileExplorerTableRowState();
}

class _FileExplorerTableRowState extends State<FileExplorerTableRow> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  int get _rowIndex => widget.rowIndex;

  FileListingResponse get _fileContainer => widget.fileContainer;

  Future<void> _navigateToNextPath(FileListingResponse fileContainer) async {
    if (fileContainer.file.isDir) {
      return _fileExplorerScreenStore
          .setCurrentPath(fileContainer.file.fullPath);
    }

    /// if the file extension is supported by the archiver then open the archive
    if (fileContainer.isSupported) {
      return _fileExplorerScreenStore.navigateToSource(
        fullPath: '',
        currentArchiveFilepath: fileContainer.file.fullPath,
        source: FileExplorerSource.ARCHIVE,
        clearStack: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        /// mouse right click
        if (event.buttons == 2) {
          showMenu(
            elevation: 2,
            context: context,
            position: RelativeRect.fromLTRB(
              event.position.dx,
              event.position.dy,
              event.position.dx,
              event.position.dy,
            ),
            items: const <PopupMenuItem<String>>[
              PopupMenuItem(value: 'test1', child: Textography('test1')),
              PopupMenuItem(value: 'test2', child: Textography('test2')),
            ],
          );
        }
      },
      child: InkWellExtended(
        mouseCursor: SystemMouseCursors.basic,
        onDoubleTap: () {
          _navigateToNextPath(_fileContainer);
        },
        onTap: () {
          _fileExplorerScreenStore.setSelectedFiles(_fileContainer);
        },
        child: Observer(builder: (_) {
          final _selectedFiles = _fileExplorerScreenStore.selectedFiles;
          final _isSelected = _selectedFiles.contains(_fileContainer);

          return FileExplorerTableRowTile(
            isSelected: _isSelected,
            rowIndex: _rowIndex,
            fileContainer: _fileContainer,
          );
        }),
      ),
    );
  }
}
