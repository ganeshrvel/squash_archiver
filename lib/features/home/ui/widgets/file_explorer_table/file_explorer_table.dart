import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:scrollable_positioned_list_extended/scrollable_positioned_list_extended.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_datasource_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_header.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_row.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/models/file_explorer_table_row_entity.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/models/file_explorer_table_selection.dart';
import 'package:squash_archiver/helpers/keyboard_activators.dart';
import 'package:squash_archiver/utils/log/log.dart';
import 'package:squash_archiver/utils/utils/math.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

enum _NavigationDirection { DOWN, UP }

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

  late final ItemScrollController _itemScrollController =
      ItemScrollController();

  late final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  _NavigationDirection _navigationDirection = _NavigationDirection.DOWN;

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
                  _itemScrollController.isAttached) {
                _itemScrollController.jumpTo(
                  index: 0,
                );
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
  }

  void _handleOnArrowDownShiftKeyPress() {
    //todo fix the toggling of the selected keys on shift down

    _handleOnArrowDownKeyPress(appendRowSelection: true);
  }

  void _scrollToRow({
    required int index,
  }) {
    var isIndexVisible = false;
    for (final itemPosition in _itemPositionsListener.itemPositions.value) {
      if (itemPosition.index == index) {
        if (itemPosition.itemLeadingEdge < 1 &&
            itemPosition.itemTrailingEdge < 1) {
          isIndexVisible = true;
          break;
        }
      }
    }

    if (!isIndexVisible) {
      _itemScrollController.getAutoScrollController?.scrollToIndex(
        index,
        duration: const Duration(milliseconds: 1),
      );
    }
  }

  void _handleOnArrowDownKeyPress({bool appendRowSelection = false}) {
    if (_fileExplorerTableDataSourceStore.rows.isEmpty) {
      return;
    }

    final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;

    var nextRowIndex = 0;
    if (lastSelectedRow != null) {
      nextRowIndex = lastSelectedRow.second.index + 1;
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
      toggleSelection: false,
      appendRowSelection: appendRowSelection,
    );

    _scrollToRow(
      index: nextRowToNavigateTo.value.index,
    );
  }

  void _handleOnArrowUpShiftKeyPress() {
    //todo fix the toggling of the selected keys on shift up
    _handleOnArrowUpKeyPress(appendRowSelection: true);
  }

  void _handleOnArrowUpMetaKeyPress() {
    _fileExplorerScreenStore.gotoPrevDirectory();
  }

  void _handleOnArrowUpKeyPress({bool appendRowSelection = false}) {
    if (_fileExplorerTableDataSourceStore.rows.isEmpty) {
      return;
    }

    final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;

    var nextRowIndex = _fileExplorerTableDataSourceStore.rows.length - 1;
    if (lastSelectedRow != null) {
      nextRowIndex = lastSelectedRow.second.index - 1;
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
      toggleSelection: false,
      appendRowSelection: appendRowSelection,
    );

    _scrollToRow(
      index: nextRowToNavigateTo.value.index,
    );
  }

  void _handleOnDoubleTap({
    required FileExplorerTableRowEntity row,
    required int index,
  }) {
    _onDoubleTap(
      row: row,
    );
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
  }

  void _handleOnKeyAMetaPress() {
    _fileExplorerTableDataSourceStore.selectAll();

    _onTap(
      selectedRows: _fileExplorerTableDataSourceStore.selectedRows,
    );
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

                  return ScrollablePositionedList.builder(
                    padding: const EdgeInsets.only(top: 5),
                    initialScrollIndex: 0,
                    itemPositionsListener: _itemPositionsListener,
                    itemScrollController: _itemScrollController,
                    itemCount: _fileExplorerTableDataSourceStore.rowCount,
                    itemBuilder: (context, index) {
                      final rowValueGroup =
                          _fileExplorerTableDataSourceStore.getRowValueGroup(
                        index,
                      );

                      return FileExplorerTableRow(
                        key: Key(rowValueGroup.row.rowKey),
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
