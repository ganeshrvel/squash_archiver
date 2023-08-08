import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_datasource_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_header.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_row.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/models/file_explorer_table_row_entity.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/models/file_explorer_table_selection.dart';
import 'package:squash_archiver/helpers/keyboard_activators.dart';
import 'package:squash_archiver/utils/utils/math.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

enum _NavigationDirection { DOWN, UP }

typedef RowRendererProps = ({
  GlobalKey globalKey,
});

/// A scrollable data table with sorting and selection.
class FileExplorerTable extends StatefulWidget {
  const FileExplorerTable({
    super.key,
    required this.fileExplorerScaffoldScrollController,
    required this.fileExplorerTableDataSourceStore,
    required this.rowHeight,
    required this.onTap,
    required this.onDoubleTap,
    required this.fileExplorerScreenStore,
    required this.onColumnHeaderTap,
    required this.fileExplorerFocusNode,
  });

  /// The height of every row.
  final double rowHeight;

  /// Optionally override the scrollController.
  final ScrollController fileExplorerScaffoldScrollController;

  final FileExplorerTableDataSourceStore fileExplorerTableDataSourceStore;

  final void Function({
    required Map<String, FileListingResponse> selectedRows,
  }) onTap;

  final void Function({
    required FileExplorerTableRowEntity row,
  }) onDoubleTap;

  final FileExplorerScreenStore fileExplorerScreenStore;

  final void Function({
    required OrderBy? orderBy,
    required OrderDir? orderDir,
  }) onColumnHeaderTap;

  final FocusNode fileExplorerFocusNode;

  @override
  State<StatefulWidget> createState() => _FileExplorerTableState();
}

class _FileExplorerTableState extends SfWidget<FileExplorerTable> {
  void Function({
    required Map<String, FileListingResponse> selectedRows,
  }) get _onTap => widget.onTap;

  void Function({
    required FileExplorerTableRowEntity row,
  }) get _onDoubleTap => widget.onDoubleTap;

  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  void Function({
    required OrderBy? orderBy,
    required OrderDir? orderDir,
  }) get _onColumnHeaderTap => widget.onColumnHeaderTap;

  FocusNode get _fileExplorerFocusNode => widget.fileExplorerFocusNode;

  late final FocusNode _focusNode = FocusNode();

  double get _rowHeight => widget.rowHeight;

  late final List<ReactionDisposer> _disposers;

  FileExplorerTableDataSourceStore get _fileExplorerTableDataSourceStore =>
      widget.fileExplorerTableDataSourceStore;

  ScrollController get _fileExplorerScaffoldScrollController =>
      widget.fileExplorerScaffoldScrollController;

  late final ScrollController _scrollController = ScrollController();

  _NavigationDirection _multipleNavigationDirection = _NavigationDirection.DOWN;

  @override
  void initState() {
    _disposers = [
      reaction(
        (_) => _fileExplorerScreenStore.currentPath,
        (String currentPath) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (mounted &&
                  _fileExplorerTableDataSourceStore.rows.isNotEmpty &&
                  _scrollController.hasClients) {
                _scrollController.jumpTo(0);
              }
            },
          );
        },
      ),
    ];

    super.initState();
  }

  @override
  void dispose() {
    disposeStore(_disposers);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _select({
    required List<FileExplorerTableRowEntity> rows,
    required int index,
    bool appendRowSelection = false,
    bool toggleSelection = true,
  }) {
    _fileExplorerTableDataSourceStore.select(
      rows: List.generate(
        rows.length,
        (index) => FileExplorerTableRowsSelection(
          rowKey: rows[index].rowKey,
          value: rows[index].value,
        ),
      ),
      append: appendRowSelection,
      toggleSelection: toggleSelection,
    );
  }

  void _handleSingleTap({
    required FileExplorerTableRowEntity row,
    required int index,
    required bool appendRowSelection,
  }) {
    _select(
      rows: [row],
      index: index,
      appendRowSelection: appendRowSelection,
      toggleSelection: true,
    );

    _multipleNavigationDirection = _NavigationDirection.DOWN;
  }

  ({int firstFullyVisibleIndex, int lastFullyVisibleIndex}) _findVisibleRows() {
    final firstVisibleIndex = (_scrollController.offset / _rowHeight).floor();
    final lastVisibleIndex = ((_scrollController.offset +
                _scrollController.position.viewportDimension) /
            _rowHeight)
        .ceil();

    var firstFullyVisibleIndex = firstVisibleIndex;
    var lastFullyVisibleIndex = lastVisibleIndex - 1;

    // Find the first fully visible index
    for (var idx = firstVisibleIndex; idx <= lastVisibleIndex; idx++) {
      final itemPosition = idx * _rowHeight;
      final itemBottom = itemPosition + _rowHeight;
      final viewportTop = _scrollController.offset;
      final viewportBottom = _scrollController.offset +
          _scrollController.position.viewportDimension;

      if (itemPosition >= viewportTop && itemBottom <= viewportBottom) {
        firstFullyVisibleIndex = idx;
        break;
      }
    }

    // Find the last fully visible index
    for (var idx = lastVisibleIndex - 1; idx >= firstVisibleIndex; idx--) {
      final itemPosition = idx * _rowHeight;
      final itemBottom = itemPosition + _rowHeight;
      final viewportTop = _scrollController.offset;
      final viewportBottom = _scrollController.offset +
          _scrollController.position.viewportDimension;

      if (itemPosition >= viewportTop && itemBottom <= viewportBottom) {
        lastFullyVisibleIndex = idx;
        break;
      }
    }

    return (
      firstFullyVisibleIndex: firstFullyVisibleIndex,
      lastFullyVisibleIndex: lastFullyVisibleIndex,
    );
  }

  void _scrollToRow({
    required FileListingResponse row,
    required _NavigationDirection direction,
  }) {
    final (
      firstFullyVisibleIndex: firstFullyVisibleIndex,
      lastFullyVisibleIndex: lastFullyVisibleIndex
    ) = _findVisibleRows();

    if (!isWithinRange(
      value: row.index,
      min: firstFullyVisibleIndex,
      max: lastFullyVisibleIndex - 1,
      inclusiveOfMax: true,
    )) {
      double offset;
      if (direction == _NavigationDirection.DOWN) {
        offset = (row.index + 2) * _rowHeight -
            _scrollController.position.viewportDimension;
      } else {
        offset = row.index * _rowHeight;
      }

      final refinedOffset = coerceIn<double>(
        value: offset,
        min: 0,
        max: _scrollController.position.maxScrollExtent,
      );

      _scrollController.jumpTo(refinedOffset);
    }
  }

  void _handleOnArrowDownShiftKeyPress() {
    _handleOnArrowDownKeyPress(
      appendRowSelection: true,
      isShiftKeyPressed: true,
    );
  }

  void _handleOnArrowDownKeyPress({
    bool appendRowSelection = false,
    bool isShiftKeyPressed = false,
  }) {
    if (_fileExplorerTableDataSourceStore.rows.isEmpty) {
      return;
    }

    var toggleSelection = false;
    var nextRowIndex = 0;
    final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;

    if (isShiftKeyPressed &&
        _multipleNavigationDirection != _NavigationDirection.DOWN) {
      nextRowIndex = 0;
      if (lastSelectedRow != null) {
        nextRowIndex = lastSelectedRow.second.index;
        toggleSelection = true;
      }

      final rowGroup = _fileExplorerTableDataSourceStore.getRowValueGroup(
        nextRowIndex,
      );

      if (rowGroup.nextRow != null) {
        if (!rowGroup.nextRow!.isSelected()) {
          _multipleNavigationDirection = _NavigationDirection.DOWN;

          nextRowIndex = nextRowIndex + 1;
          toggleSelection = false;
        }
      } else {
        return;
      }
    } else {
      nextRowIndex = 0;
      if (lastSelectedRow != null) {
        nextRowIndex = lastSelectedRow.second.index + 1;
      }

      _multipleNavigationDirection = _NavigationDirection.DOWN;

      // else {
      // //todo when the pivot hits selected rows, it cannot toggle thus cannot proceed navigation
      // }
    }

    final nextIndexToNavigateTo = coerceIn(
      value: nextRowIndex,
      min: 0,
      max: _fileExplorerTableDataSourceStore.rows.length - 1,
    );
    final nextRow =
        _fileExplorerTableDataSourceStore.rows[nextIndexToNavigateTo];

    final nextRowToNavigateTo = FileExplorerTableRowEntity(
      isSelected: () => _fileExplorerTableDataSourceStore.isRowSelected(
        nextRow.uniqueId,
      ),
      value: nextRow,
      rowKey: nextRow.uniqueId,
    );

    _select(
      index: nextRowToNavigateTo.value.index,
      rows: [nextRowToNavigateTo],
      toggleSelection: toggleSelection,
      appendRowSelection: appendRowSelection,
    );

    _scrollToRow(
      row: nextRowToNavigateTo.value,
      direction: _NavigationDirection.DOWN,
    );
  }

  void _handleOnArrowUpShiftKeyPress() {
    _handleOnArrowUpKeyPress(
      appendRowSelection: true,
      isShiftKeyPressed: true,
    );
  }

  void _handleOnArrowUpMetaKeyPress() {
    _fileExplorerScreenStore.gotoPrevDirectory();
  }

  void _handleOnArrowUpKeyPress({
    bool appendRowSelection = false,
    bool isShiftKeyPressed = false,
  }) {
    if (_fileExplorerTableDataSourceStore.rows.isEmpty) {
      return;
    }

    var toggleSelection = false;
    var prevRowIndex = 0;
    final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;

    if (isShiftKeyPressed &&
        _multipleNavigationDirection != _NavigationDirection.UP) {
      prevRowIndex = _fileExplorerTableDataSourceStore.rows.length - 1;
      if (lastSelectedRow != null) {
        prevRowIndex = lastSelectedRow.second.index;
        toggleSelection = true;
      }

      final rowGroup = _fileExplorerTableDataSourceStore.getRowValueGroup(
        prevRowIndex,
      );

      if (rowGroup.prevRow != null) {
        if (!rowGroup.prevRow!.isSelected()) {
          _multipleNavigationDirection = _NavigationDirection.UP;

          prevRowIndex = prevRowIndex - 1;
          toggleSelection = false;
        }
      } else {
        return;
      }
    } else {
      prevRowIndex = 0;
      if (lastSelectedRow != null) {
        prevRowIndex = lastSelectedRow.second.index - 1;
      }

      _multipleNavigationDirection = _NavigationDirection.UP;

      // else {
      // //todo when the pivot hits selected rows, it cannot toggle thus cannot proceed navigation
      // }
    }

    final prevIndexToNavigateTo = coerceIn(
      value: prevRowIndex,
      min: 0,
      max: _fileExplorerTableDataSourceStore.rows.length - 1,
    );
    final prevRow =
        _fileExplorerTableDataSourceStore.rows[prevIndexToNavigateTo];
    final prevRowToNavigateTo = FileExplorerTableRowEntity(
      isSelected: () => _fileExplorerTableDataSourceStore.isRowSelected(
        prevRow.uniqueId,
      ),
      value: prevRow,
      rowKey: prevRow.uniqueId,
    );

    _select(
      index: prevRowToNavigateTo.value.index,
      rows: [prevRowToNavigateTo],
      toggleSelection: toggleSelection,
      appendRowSelection: appendRowSelection,
    );

    _scrollToRow(
      row: prevRowToNavigateTo.value,
      direction: _NavigationDirection.UP,
    );
  }

  void _handleOnDoubleTap({
    required FileExplorerTableRowEntity row,
    required int index,
  }) {
    _onDoubleTap(
      row: row,
    );

    _multipleNavigationDirection = _NavigationDirection.DOWN;
  }

  void _processTaps({
    required FileExplorerTableRowEntity row,
    required int index,
  }) {
    final isMetaPressed = KeyboardActivators.isMetaPressed();
    final isShiftPressed = KeyboardActivators.isShiftPressed();

    if (isMetaPressed && isShiftPressed) {
      _handleSingleTap(
        row: row,
        index: index,
        appendRowSelection: true,
      );
    } else if (isMetaPressed) {
      _handleSingleTap(
        row: row,
        index: index,
        appendRowSelection: true,
      );
    } else if (isShiftPressed) {
      final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;

      var prevRowIndex = 0;
      if (lastSelectedRow != null) {
        prevRowIndex = lastSelectedRow.second.index;
      }

      var rangeStart = prevRowIndex;
      var rangeEnd = coerceIn(
        value: index + 1,
        min: 0,
        max: _fileExplorerTableDataSourceStore.rows.length,
      );

      /// when a row with lower index or the same index is clicked then swap out the start and end indices
      if (rangeStart >= rangeEnd) {
        final tempRangeStart = rangeStart;
        rangeStart = coerceIn(
          value: rangeEnd - 1,
          min: 0,
          max: _fileExplorerTableDataSourceStore.rows.length,
        );
        rangeEnd = tempRangeStart;
      }

      final _lastSelectedRowRange = _fileExplorerTableDataSourceStore.rows
          .getRange(
            rangeStart,
            rangeEnd,
          )
          .toList();

      _select(
        index: prevRowIndex,
        rows: List.generate(
          _lastSelectedRowRange.length,
          (index) => FileExplorerTableRowEntity(
            isSelected: () => _fileExplorerTableDataSourceStore.isRowSelected(
              _lastSelectedRowRange[index].uniqueId,
            ),
            value: _lastSelectedRowRange[index],
            rowKey: _lastSelectedRowRange[index].uniqueId,
          ),
        ),
        toggleSelection: false,
        appendRowSelection: true,
      );
    } else {
      _handleSingleTap(
        row: row,
        index: index,
        appendRowSelection: false,
      );
    }
  }

  void _initializeTap({
    required FileExplorerTableRowEntity row,
    required int index,
  }) {
    setState(() {
      _processTaps(
        index: index,
        row: row,
      );
    });
    _onTap(
      selectedRows: _fileExplorerTableDataSourceStore.selectedRows,
    );
  }

  void _handleOnEnterKeyPress() {
    final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;

    if (lastSelectedRow == null) {
      return;
    }

    final nextRowToNavigateTo = FileExplorerTableRowEntity(
      isSelected: () => _fileExplorerTableDataSourceStore.isRowSelected(
        lastSelectedRow.first,
      ),
      value: lastSelectedRow.second,
      rowKey: lastSelectedRow.first,
    );

    _onDoubleTap(
      row: nextRowToNavigateTo,
    );
  }

  void _handleOnEscapeKeyPress() {
    _fileExplorerTableDataSourceStore.reset();

    _onTap(
      selectedRows: _fileExplorerTableDataSourceStore.selectedRows,
    );

    _multipleNavigationDirection = _NavigationDirection.DOWN;
  }

  void _handleOnKeyAMetaPress() {
    _fileExplorerTableDataSourceStore.selectAll();

    _onTap(
      selectedRows: _fileExplorerTableDataSourceStore.selectedRows,
    );

    _multipleNavigationDirection = _NavigationDirection.UP;
  }

  void _initializeShortcutsActivator(VoidCallback cb) {
    setState(() {
      cb();
    });
    _onTap(
      selectedRows: _fileExplorerTableDataSourceStore.selectedRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// A map from column index to its TableColumnWidth.
    /// Every Table widget needs this, so it is created once and cached here.
    final columnWidths = _fileExplorerTableDataSourceStore.colDefs
        .map((colDef) => colDef.width)
        .toList()
        .asMap();

    return Column(
      children: [
        Observer(
          builder: (BuildContext context) {
            final _orderBy = _fileExplorerTableDataSourceStore.orderBy;
            final _orderDir = _fileExplorerTableDataSourceStore.orderDir;

            return FileExplorerTableHeader(
              colDefs: _fileExplorerTableDataSourceStore.colDefs,
              orderBy: _orderBy,
              orderDir: _orderDir,
              onColumnHeaderTap: (colDef) {
                _fileExplorerTableDataSourceStore.toggleDirection(
                  colDef: colDef,
                );

                _onColumnHeaderTap(
                  orderBy: _fileExplorerTableDataSourceStore.orderBy,
                  orderDir: _fileExplorerTableDataSourceStore.orderDir,
                );
              },
            );
          },
        ),
        Expanded(
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                  _initializeShortcutsActivator(
                    _handleOnArrowDownKeyPress,
                  ),
              const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                  _initializeShortcutsActivator(
                    _handleOnArrowUpKeyPress,
                  ),
              const SingleActivator(LogicalKeyboardKey.arrowUp, shift: true):
                  () => _initializeShortcutsActivator(
                        _handleOnArrowUpShiftKeyPress,
                      ),
              const SingleActivator(LogicalKeyboardKey.arrowUp, meta: true):
                  () => _handleOnArrowUpMetaKeyPress(),
              const SingleActivator(LogicalKeyboardKey.arrowDown, shift: true):
                  () => _initializeShortcutsActivator(
                        _handleOnArrowDownShiftKeyPress,
                      ),
              const SingleActivator(LogicalKeyboardKey.enter): () =>
                  _handleOnEnterKeyPress(),
              const SingleActivator(LogicalKeyboardKey.escape): () =>
                  _initializeShortcutsActivator(
                    _handleOnEscapeKeyPress,
                  ),
              const SingleActivator(LogicalKeyboardKey.keyA, meta: true): () =>
                  _initializeShortcutsActivator(
                    _handleOnKeyAMetaPress,
                  ),
            },
            child: Focus(
              autofocus: true,
              child: Observer(
                builder: (BuildContext context) {
                  final selectedRows =
                      _fileExplorerTableDataSourceStore.selectedRows;

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 5),
                    controller: _scrollController,
                    itemCount: _fileExplorerTableDataSourceStore.rowCount,
                    itemExtent: _rowHeight,
                    itemBuilder: (context, index) {
                      final rowValueGroup =
                          _fileExplorerTableDataSourceStore.getRowValueGroup(
                        index,
                      );

                      return FileExplorerTableRow(
                        key: ValueKey(rowValueGroup.row.rowKey),
                        index: index,
                        rowHeight: _rowHeight,
                        columnWidths: columnWidths,
                        colDefs: _fileExplorerTableDataSourceStore.colDefs,
                        fileExplorerTableDataSourceStore:
                            _fileExplorerTableDataSourceStore,
                        rowValueGroup: rowValueGroup,
                        onTap: _initializeTap,
                        onDoubleTap: _handleOnDoubleTap,
                        selectedRows: selectedRows,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
