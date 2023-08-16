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
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/list.dart';
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
    required bool appendRowSelection,
  }) {
    _select(
      rows: [row],
      appendRowSelection: appendRowSelection,
      toggleSelection: true,
    );

    _multipleNavigationDirection = _NavigationDirection.DOWN;
  }

  /// This function finds the indices of the first and last fully visible rows within the viewport.
  /// It calculates these indices based on the current scroll position and row height.
  /// Returns a record containing the firstFullyVisibleIndex and lastFullyVisibleIndex.
  ({int firstFullyVisibleIndex, int lastFullyVisibleIndex}) _findVisibleRows() {
    // Calculate the index of the first and last partially visible rows
    final firstVisibleIndex = (_scrollController.offset / _rowHeight).floor();
    final lastVisibleIndex = ((_scrollController.offset +
                _scrollController.position.viewportDimension) /
            _rowHeight)
        .ceil();

    // Initialize with partially visible indices
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

  /// Scroll to the specified row ensuring it is fully visible within the viewport.
  /// Adjusts the scroll offset based on the navigation direction and row index.
  /// If the row is not fully visible, the scroll offset is adjusted for better user experience.
  void _scrollToRow({
    required FileListingResponse row,
    required _NavigationDirection direction,
  }) {
    // Find the indices of the first and last fully visible rows within the viewport
    final (
      firstFullyVisibleIndex: firstFullyVisibleIndex,
      lastFullyVisibleIndex: lastFullyVisibleIndex
    ) = _findVisibleRows();

    // Check if the row is fully visible within the viewport
    if (!isWithinRange(
      value: row.index,
      min: firstFullyVisibleIndex,
      max: lastFullyVisibleIndex - 1,
      inclusiveOfMax: true,
    )) {
      double offset;
      if (direction == _NavigationDirection.DOWN) {
        // Calculate the offset for scrolling down while preserving highlighting
        offset = (row.index + 2) * _rowHeight -
            _scrollController.position.viewportDimension;
      } else {
        // Calculate the offset for scrolling up while preserving highlighting
        offset = (row.index * _rowHeight) - (_rowHeight - 2);
      }

      // Refine the offset within the valid range
      final refinedOffset = coerceIn<double>(
        value: offset,
        min: 0,
        max: _scrollController.position.maxScrollExtent,
      );

      // Jump to the refined offset to ensure the row is fully visible
      _scrollController.jumpTo(refinedOffset);
    }
  }

  void _handleOnArrowDownShiftKeyPress() {
    _handleOnArrowDownKeyPress(
      appendRowSelection: true,
      isShiftKeyPressed: true,
    );
  }

  /// Retrieves a list of rows from the previous selected group relative to the
  /// [prevRowToNavigateTo] row.
  /// If the row immediately preceding [prevRowToNavigateTo] is selected, this function
  /// will merge the selection block and include all rows from that group.
  List<FileExplorerTableRowEntity> _getRowsInPrevSelectedGroup({
    required FileExplorerTableRowEntity prevRowToNavigateTo,
  }) {
    // Initialize a list to store rows from the previous selected group
    final rowsInPrevSelectedGroup = <FileExplorerTableRowEntity>[];

    // Retrieve the row immediately preceding [prevRowToNavigateTo]
    final prevToPrevRow = _fileExplorerTableDataSourceStore.rows
        .at(prevRowToNavigateTo.value.index - 1);

    // Check if the previous-to-previous row is selected
    if (prevToPrevRow != null &&
        _fileExplorerTableDataSourceStore
                .selectedRows[prevToPrevRow.uniqueId] !=
            null) {
      // Iterate from the previous-to-previous row upwards, looking for the top selected row
      for (var idx = prevToPrevRow.index; idx >= 0; idx--) {
        final _uniqueId = _fileExplorerTableDataSourceStore.rows[idx].uniqueId;

        // If a selected row is encountered, add it to the rowsInPrevSelectedGroup list
        if (_fileExplorerTableDataSourceStore.selectedRows[_uniqueId] == null) {
          break; // Stop when a non-selected row is encountered
        }

        // Create a new instance of FileExplorerTableRowEntity with isSelected set to true,
        // using the row data from the data source store
        rowsInPrevSelectedGroup.add(
          FileExplorerTableRowEntity(
            isSelected: () => true,
            value: _fileExplorerTableDataSourceStore.rows[idx],
            rowKey: _uniqueId,
          ),
        );
      }
    }

    // Return the list of rows from the previous selected group
    return rowsInPrevSelectedGroup;
  }

  /// Retrieves a list of rows from the next selected group relative to the
  /// [nextRowToNavigateTo] row.
  /// If the row immediately following [nextRowToNavigateTo] is selected, this function
  /// will merge the selection block and include all rows from that group.
  List<FileExplorerTableRowEntity> _getRowsInNextSelectedGroup({
    required FileExplorerTableRowEntity nextRowToNavigateTo,
  }) {
    // Initialize a list to store rows from the next selected group
    final rowsInNextSelectedGroup = <FileExplorerTableRowEntity>[];

    // Retrieve the row immediately following [nextRowToNavigateTo]
    final nextToNextRow = _fileExplorerTableDataSourceStore.rows
        .at(nextRowToNavigateTo.value.index + 1);

    // Check if the next-to-next row is selected
    if (nextToNextRow != null &&
        _fileExplorerTableDataSourceStore
                .selectedRows[nextToNextRow.uniqueId] !=
            null) {
      // Iterate from the next-to-next row downwards, looking for the bottom selected row
      for (var idx = nextToNextRow.index;
          idx < _fileExplorerTableDataSourceStore.rows.length - 1;
          idx++) {
        final _uniqueId = _fileExplorerTableDataSourceStore.rows[idx].uniqueId;

        // If a selected row is encountered, add it to the rowsInNextSelectedGroup list
        if (_fileExplorerTableDataSourceStore.selectedRows[_uniqueId] == null) {
          break; // Stop when a non-selected row is encountered
        }

        // Create a new instance of FileExplorerTableRowEntity with isSelected set to true,
        // using the row data from the data source store
        rowsInNextSelectedGroup.add(
          FileExplorerTableRowEntity(
            isSelected: () => true,
            value: _fileExplorerTableDataSourceStore.rows[idx],
            rowKey: _uniqueId,
          ),
        );
      }
    }

    // Return the list of rows from the next selected group
    return rowsInNextSelectedGroup;
  }

  /// Handles the behavior when the down arrow key is pressed.
  /// It adjusts row selection, navigation, and scrolling based on keyboard input.
  void _handleOnArrowDownKeyPress({
    bool appendRowSelection = false,
    bool isShiftKeyPressed = false,
  }) {
    // If there are no rows, return without performing any action
    if (_fileExplorerTableDataSourceStore.rows.isEmpty) {
      return;
    }

    // Initialize variables for handling row selection and navigation
    var toggleSelection = false;
    final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;
    var rowsInNextSelectedGroup = <FileExplorerTableRowEntity>[];
    FileExplorerTableRowEntity nextRowToNavigateTo;

    if (isShiftKeyPressed &&
        _multipleNavigationDirection != _NavigationDirection.DOWN) {
      // Handling shift key behavior and direction change
      // Toggle the row to navigate to if shift key is pressed and direction changes
      var nextRowIndex = 0;
      if (lastSelectedRow != null) {
        nextRowIndex = lastSelectedRow.second.index;
        toggleSelection = true;
      }

      // Retrieve the row group for the next index to navigate to
      final rowGroup = _fileExplorerTableDataSourceStore.getRowValueGroup(
        nextRowIndex,
      );

      if (rowGroup.nextRow != null) {
        // Reverse navigation direction if the next row is not selected
        if (!rowGroup.nextRow!.isSelected()) {
          _multipleNavigationDirection = _NavigationDirection.DOWN;
          nextRowIndex = nextRowIndex + 1;
          toggleSelection = false;
        }
      } else {
        return; // Return if the row to navigate to is null
      }

      // Calculate the next index to navigate to and retrieve the corresponding row
      final nextIndexToNavigateTo = coerceIn(
        value: nextRowIndex,
        min: 0,
        max: _fileExplorerTableDataSourceStore.rows.length - 1,
      );
      final nextRow =
          _fileExplorerTableDataSourceStore.rows[nextIndexToNavigateTo];

      // Create a FileExplorerTableRowEntity instance for the next row to navigate to
      nextRowToNavigateTo = FileExplorerTableRowEntity(
        isSelected: () => _fileExplorerTableDataSourceStore.isRowSelected(
          nextRow.uniqueId,
        ),
        value: nextRow,
        rowKey: nextRow.uniqueId,
      );
    } else {
      var nextRowIndex = 0;
      // If the last selected row is not null, calculate the next index to navigate to
      if (lastSelectedRow != null) {
        nextRowIndex = coerceIn(
          value: lastSelectedRow.second.index + 1,
          min: 0,
          max: _fileExplorerTableDataSourceStore.rows.length - 1,
        );
      }

      // Retrieve the row for the calculated next index to navigate to
      final nextRow = _fileExplorerTableDataSourceStore.rows[nextRowIndex];
      nextRowToNavigateTo = FileExplorerTableRowEntity(
        isSelected: () => _fileExplorerTableDataSourceStore.isRowSelected(
          nextRow.uniqueId,
        ),
        value: nextRow,
        rowKey: nextRow.uniqueId,
      );

      // Retrieve rows in the next selected group for better navigation
      rowsInNextSelectedGroup = _getRowsInNextSelectedGroup(
        nextRowToNavigateTo: nextRowToNavigateTo,
      );

      _multipleNavigationDirection = _NavigationDirection.DOWN;
    }

    // Select rows and adjust scrolling based on the calculated information
    if (isNotNullOrEmpty(rowsInNextSelectedGroup)) {
      _select(
        rows: [
          nextRowToNavigateTo,
          ...rowsInNextSelectedGroup,
        ],
        toggleSelection: false,
        appendRowSelection: appendRowSelection,
      );

      _scrollToRow(
        row: rowsInNextSelectedGroup.getLastOrNull()!.value,
        direction: _NavigationDirection.DOWN,
      );
    } else {
      _select(
        rows: [
          nextRowToNavigateTo,
        ],
        toggleSelection: toggleSelection,
        appendRowSelection: appendRowSelection,
      );

      _scrollToRow(
        row: nextRowToNavigateTo.value,
        direction: _NavigationDirection.DOWN,
      );
    }
  }

  void _handleOnArrowUpShiftKeyPress() {
    _handleOnArrowUpKeyPress(
      appendRowSelection: true,
      isShiftKeyPressed: true,
    );
  }

  /// Handles the behavior when the up arrow key is pressed.
  /// It adjusts row selection, navigation, and scrolling based on keyboard input.
  void _handleOnArrowUpKeyPress({
    bool appendRowSelection = false,
    bool isShiftKeyPressed = false,
  }) {
    // If there are no rows, return without performing any action
    if (_fileExplorerTableDataSourceStore.rows.isEmpty) {
      return;
    }

    // Initialize variables for handling row selection and navigation
    var toggleSelection = false;
    final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;
    var rowsInPrevSelectedGroup = <FileExplorerTableRowEntity>[];
    FileExplorerTableRowEntity prevRowToNavigateTo;

    if (isShiftKeyPressed &&
        _multipleNavigationDirection != _NavigationDirection.UP) {
      // Handling shift key behavior and direction change
      // Toggle the row to navigate to if shift key is pressed and direction changes
      var prevRowIndex = _fileExplorerTableDataSourceStore.rows.length - 1;
      if (lastSelectedRow != null) {
        prevRowIndex = lastSelectedRow.second.index;
        toggleSelection = true;
      }

      // Retrieve the row group for the previous index to navigate to
      final rowGroup = _fileExplorerTableDataSourceStore.getRowValueGroup(
        prevRowIndex,
      );

      if (rowGroup.prevRow != null) {
        // Reverse navigation direction if the previous row is not selected
        if (!rowGroup.prevRow!.isSelected()) {
          _multipleNavigationDirection = _NavigationDirection.UP;
          prevRowIndex = prevRowIndex - 1;
          toggleSelection = false;
        }
      } else {
        return; // Return if the row to navigate to is null
      }

      // Calculate the previous index to navigate to and retrieve the corresponding row
      final prevIndexToNavigateTo = coerceIn(
        value: prevRowIndex,
        min: 0,
        max: _fileExplorerTableDataSourceStore.rows.length - 1,
      );
      final prevRow =
          _fileExplorerTableDataSourceStore.rows[prevIndexToNavigateTo];
      prevRowToNavigateTo = FileExplorerTableRowEntity(
        isSelected: () => _fileExplorerTableDataSourceStore.isRowSelected(
          prevRow.uniqueId,
        ),
        value: prevRow,
        rowKey: prevRow.uniqueId,
      );
    } else {
      var prevRowIndex = 0;
      // If the last selected row is not null, calculate the previous index to navigate to
      if (lastSelectedRow != null) {
        prevRowIndex = coerceIn(
          value: lastSelectedRow.second.index - 1,
          min: 0,
          max: _fileExplorerTableDataSourceStore.rows.length - 1,
        );
      }

      // Retrieve the row for the calculated previous index to navigate to
      final prevRow = _fileExplorerTableDataSourceStore.rows[prevRowIndex];
      prevRowToNavigateTo = FileExplorerTableRowEntity(
        isSelected: () => _fileExplorerTableDataSourceStore.isRowSelected(
          prevRow.uniqueId,
        ),
        value: prevRow,
        rowKey: prevRow.uniqueId,
      );

      // Retrieve rows in the previous selected group for better navigation
      rowsInPrevSelectedGroup = _getRowsInPrevSelectedGroup(
        prevRowToNavigateTo: prevRowToNavigateTo,
      );

      _multipleNavigationDirection = _NavigationDirection.UP;
    }

    // Select rows and adjust scrolling based on the calculated information
    if (isNotNullOrEmpty(rowsInPrevSelectedGroup)) {
      _select(
        rows: [
          prevRowToNavigateTo,
          ...rowsInPrevSelectedGroup,
        ],
        toggleSelection: false,
        appendRowSelection: appendRowSelection,
      );

      _scrollToRow(
        row: rowsInPrevSelectedGroup.getLastOrNull()!.value,
        direction: _NavigationDirection.UP,
      );
    } else {
      _select(
        rows: [
          prevRowToNavigateTo,
        ],
        toggleSelection: toggleSelection,
        appendRowSelection: appendRowSelection,
      );

      _scrollToRow(
        row: prevRowToNavigateTo.value,
        direction: _NavigationDirection.UP,
      );
    }
  }

  void _handleOnArrowUpMetaKeyPress() {
    _fileExplorerScreenStore.gotoPrevDirectory();
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

  /// Processes tap events on a row, handling selection and navigation based on keyboard modifiers.
  void _processTaps({
    required FileExplorerTableRowEntity row,
    required int index,
  }) {
    // Check if Meta (Command) and Shift keys are pressed
    final isMetaPressed = KeyboardActivators.isMetaPressed();
    final isShiftPressed = KeyboardActivators.isShiftPressed();

    if (isMetaPressed && isShiftPressed) {
      // Handle tap with both Meta and Shift keys pressed
      _handleSingleTap(
        row: row,
        appendRowSelection: true,
      );
    } else if (isMetaPressed) {
      // Handle tap with only Meta key pressed
      _handleSingleTap(
        row: row,
        appendRowSelection: true,
      );
    } else if (isShiftPressed) {
      // Handle tap with only Shift key pressed
      final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;
      // Calculate the range of rows to select
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

      // Swap start and end indices if necessary
      if (rangeStart >= rangeEnd) {
        final tempRangeStart = rangeStart;
        rangeStart = coerceIn(
          value: rangeEnd - 1,
          min: 0,
          max: _fileExplorerTableDataSourceStore.rows.length,
        );
        rangeEnd = tempRangeStart;
      }

      // Generate and select rows within the specified range
      final _lastSelectedRowRange = _fileExplorerTableDataSourceStore.rows
          .getRange(
            rangeStart,
            rangeEnd,
          )
          .toList();
      _select(
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
      // Handle tap with no modifier keys pressed
      _handleSingleTap(
        row: row,
        appendRowSelection: false,
      );
    }
  }

  /// Initializes the tap event, processing selection and navigation.
  void _initializeTap({
    required FileExplorerTableRowEntity row,
    required int index,
  }) {
    // Update the state with tap processing and call onTap callback
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

  /// Handles behavior when the Enter key is pressed, navigating to the selected row.
  void _handleOnEnterKeyPress() {
    // Get the last selected row and navigate to the next row
    final lastSelectedRow = _fileExplorerTableDataSourceStore.lastSelectedRow;

    if (lastSelectedRow == null) {
      return; // Return if no row is selected
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

    _multipleNavigationDirection = _NavigationDirection.DOWN;
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
