import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/common/helpers/provider_helpers.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_keyboard_modifiers_store.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table_row.dart';
import 'package:squash_archiver/utils/log/log.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/inkwell_extended/inkwell_extended.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerTableRow extends StatefulWidget {
  final int rowIndex;

  final FileListingResponse fileContainer;

  const FileExplorerTableRow({
    Key key,
    @required this.fileContainer,
    @required this.rowIndex,
  })  : assert(fileContainer != null),
        assert(rowIndex != null),
        super(key: key);

  @override
  _FileExplorerTableRowState createState() => _FileExplorerTableRowState();
}

class _FileExplorerTableRowState extends State<FileExplorerTableRow> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  FileExplorerKeyboardModifiersStore get _fileExplorerKeyboardModifiersStore =>
      readProvider<FileExplorerKeyboardModifiersStore>(context);

  int get _rowIndex => widget.rowIndex;

  FileListingResponse get _fileContainer => widget.fileContainer;

  bool get _isFileSelected {
    final _selectedFiles = _fileExplorerScreenStore.selectedFiles;

    /// is file selected
    return isNotNull(
      _selectedFiles[_fileContainer.uniqueId],
    );
  }

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

  void _handleSelectFile() {
    final _activeKeyboardModifierIntent =
        _fileExplorerKeyboardModifiersStore.activeKeyboardModifierIntent;

    /// if meta key is pressed (in macos) then allow multiple selection
    _fileExplorerScreenStore.setSelectedFile(
      _fileContainer,
      appendToList: _activeKeyboardModifierIntent?.isMetaPressed == true,
    );
  }

  List<PopupMenuItem<String>> _buildContextMenuItems() {
    const _menuList = <PopupMenuItem<String>>[
      PopupMenuItem(value: 'Info', child: Textography('Info')),
      PopupMenuItem(value: 'Delete', child: Textography('Delete')),
    ];

    if (_fileExplorerScreenStore.isSourceAnArchive) {
      const _menu = [
        PopupMenuItem(value: 'Open', child: Textography('Open')),
        PopupMenuItem(value: 'Extract', child: Textography('Open')),
      ];

      _menuList.addAll(_menu);
    }

    return _menuList;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        /// mouse right click
        if (event.buttons == 2) {
          if (!_isFileSelected) {
            _handleSelectFile();
          }

          final _items = _buildContextMenuItems();

          showMenu(
            useRootNavigator: true,
            elevation: 2,
            context: context,
            position: RelativeRect.fromLTRB(
              event.position.dx,
              event.position.dy,
              event.position.dx,
              event.position.dy,
            ),
            items: _items,
          );
        }
      },
      child: InkWellExtended(
        mouseCursor: SystemMouseCursors.basic,
        onDoubleTap: () {
          _navigateToNextPath(_fileContainer);
        },
        onTap: _handleSelectFile,
        child: Observer(builder: (_) {
          /// list of selected files
          final _selectedFiles = _fileExplorerScreenStore.selectedFiles;

          /// is file selected
          final _isSelected = isNotNull(
            _selectedFiles[_fileContainer.uniqueId],
          );

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
