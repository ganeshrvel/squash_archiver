import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/helpers/provider_helpers.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_column_definition_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_datasource_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/models/file_explorer_table_row_entity.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/text/text_middle_ellipsis.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerTableDelegate extends StatefulWidget {
  const FileExplorerTableDelegate({
    super.key,
    required this.fileExplorerFocusNode,
    required this.fileExplorerScaffoldScrollController,
  });

  final FocusNode fileExplorerFocusNode;

  final ScrollController fileExplorerScaffoldScrollController;

  @override
  State<FileExplorerTableDelegate> createState() =>
      _FileExplorerTableDelegateState();
}

class _FileExplorerTableDelegateState
    extends SfWidget<FileExplorerTableDelegate> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  FocusNode get _fileExplorerFocusNode => widget.fileExplorerFocusNode;

  ScrollController get _fileExplorerScaffoldScrollController =>
      widget.fileExplorerScaffoldScrollController;

  @override
  void initState() {
    super.initState();
  }

  bool _isFileSelected(FileListingResponse fileContainer) {
    final _selectedFiles = _fileExplorerScreenStore.selectedFiles;

    /// is file selected
    return isNotNull(
      _selectedFiles[fileContainer.uniqueId],
    );
  }

  void _handleTap({
    required Map<String, FileListingResponse> selectedRows,
  }) {
    final _selectedRows = selectedRows;
    _fileExplorerScreenStore.setSelectedFiles(
      _selectedRows,
    );
  }

  void _handleDoubleTap({
    required FileExplorerTableRowEntity row,
  }) {
    final _value = row.value;

    _navigateToNextPath(_value);
  }

  void _handleColumnHeaderTap({
    required OrderBy? orderBy,
    required OrderDir? orderDir,
  }) {
    _fileExplorerScreenStore.setOrderDirOrderBy(
      orderDir: orderDir,
      orderBy: orderBy,
    );
  }

  Future<void> _navigateToNextPath(FileListingResponse fileContainer) async {
    if (fileContainer.file.isDir) {
      return _fileExplorerScreenStore
          .setCurrentPath(fileContainer.file.fullPath);
    }

    /// if the file extension is supported by the archiver then open the archive
    if (fileContainer.isArchiveSupported) {
      return _fileExplorerScreenStore.navigateToSource(
        fullPath: '',
        currentArchiveFilepath: fileContainer.file.fullPath,
        source: FileExplorerSource.ARCHIVE,
        clearStack: false,
      );
    }
  }

  TextStyle _getCellTextStyle() {
    final typography = MacosTypography.of(context);

    return typography.callout;
  }

  FileExplorerTableDataSourceStore _fileExplorerTableDataSourceStore({
    required List<FileListingResponse> fileContainers,
  }) {
    return FileExplorerTableDataSourceStore(
      rows: fileContainers,
      orderBy: _fileExplorerScreenStore.orderBy,
      orderDir: _fileExplorerScreenStore.orderDir,
      selectedRows: _fileExplorerScreenStore.getSelectedFiles(),
      colDefs: [
        FileExplorerTableColumnDefinitionStore(
          columnSortIdentifier: OrderBy.name,
          label: 'Name',
          width: const FlexColumnWidth(),
          cellBuilder: (context, row) {
            return TextMiddleEllipsis(
              row.file.name,
              textStyle: const TextStyle(),
            );
          },
        ),
        FileExplorerTableColumnDefinitionStore(
          columnSortIdentifier: OrderBy.modTime,
          label: 'Modified Date',
          width: const FixedColumnWidth(200),
          cellBuilder: (ctx, row) {
            return Textography(
              row.prettyDate,
              overflow: TextOverflow.ellipsis,
              preventAutoTextStyling: true,
            );
          },
        ),
        FileExplorerTableColumnDefinitionStore(
          columnSortIdentifier: OrderBy.size,
          label: 'Size',
          width: const FixedColumnWidth(100),
          alignment: ColumnAlignment.end,
          cellBuilder: (ctx, row) {
            return Textography(
              isNotNullOrEmpty(row.prettyFileSize) ? row.prettyFileSize : '--',
              overflow: TextOverflow.ellipsis,
              preventAutoTextStyling: true,
            );
          },
        ),
        FileExplorerTableColumnDefinitionStore(
          // sorting of the column 'Kind' is disabled
          columnSortIdentifier: null,
          label: 'Kind',
          width: const FixedColumnWidth(150),
          cellBuilder: (ctx, row) {
            return Textography(
              isNotNullOrEmpty(row.kind) ? row.kind : '--',
              preventAutoTextStyling: true,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
      ],
      rowCount: fileContainers.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final _fileContainers = _fileExplorerScreenStore.fileContainers;
        return FileExplorerTable(
          fileExplorerTableDataSourceStore: _fileExplorerTableDataSourceStore(
            fileContainers: _fileContainers,
          ),
          fileExplorerScaffoldScrollController:
              _fileExplorerScaffoldScrollController,
          fileExplorerScreenStore: _fileExplorerScreenStore,
          fileExplorerFocusNode: _fileExplorerFocusNode,
          rowHeight: 25,
          onTap: _handleTap,
          onDoubleTap: _handleDoubleTap,
          onColumnHeaderTap: _handleColumnHeaderTap,
        );
      },
    );
  }
}
