import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:dartx/dartx.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_column_definition_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/models/file_explorer_table_row_entity.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/models/file_explorer_table_selection.dart';
import 'package:squash_archiver/utils/utils/list.dart';
import 'package:squash_archiver/utils/utils/math.dart';

part 'file_explorer_table_datasource_store.g.dart';

/// The state of a [FileExplorerTable].
///
/// Supplies the data to a [FileExplorerTable] and serves as a handle to execute
/// operations on the table.
class FileExplorerTableDataSourceStore = _FileExplorerTableDataSourceStoreBase
    with _$FileExplorerTableDataSourceStore;

abstract class _FileExplorerTableDataSourceStoreBase with Store {
  _FileExplorerTableDataSourceStoreBase({
    required this.rows,
    required this.selectedRows,
    required this.orderDir,
    required this.orderBy,
    required this.rowCount,
    required this.colDefs,
  });

  final List<FileListingResponse> rows;

  @computed
  Pair<String, FileListingResponse>? get lastSelectedRow {
    return selectedRows.toList().getLastOrNull();
  }

  /// The selected rows in the table.
  @observable
  Map<String, FileListingResponse> selectedRows = ObservableMap();

  /// The order direction for sorting.
  @observable
  OrderDir? orderDir;

  /// The column to order by.
  @observable
  OrderBy? orderBy;

  /// The number of rows in the table.
  @observable
  int rowCount;

  /// The list of column definitions.
  @observable
  List<FileExplorerTableColumnDefinitionStore> colDefs;

  /// Set the [orderDir] for sorting.
  @action
  Future<void> setOrderDir(OrderDir? value) async {
    orderDir = value;
  }

  /// Set the [orderBy] column for sorting.
  @action
  Future<void> setOrderBy(OrderBy? value) async {
    orderBy = value;
  }

  /// Select rows in the table.
  ///
  /// [rows] - List of file row entities to select.
  /// [append] - True if rows should be appended to the current selection; otherwise, false to replace the selection.
  /// [toggleSelection] - True if unselected rows should be selected, and selected rows should be unselected; false otherwise.
  @action
  void select({
    required List<FileExplorerTableRowsSelection> rows,
    required bool append,
    required bool toggleSelection,
  }) {
    if (!append) {
      selectedRows = {};
    }

    rows.forEach((row) {
      if (toggleSelection && selectedRows.containsKey(row.rowKey)) {
        selectedRows.remove(row.rowKey);
      } else {
        selectedRows[row.rowKey] = row.value;
      }
    });
  }

  /// Reselect rows in the table.
  @action
  void reset() {
    selectedRows = {};
  }

  /// Select all rows in the table.
  @action
  void selectAll() {
    selectedRows = {for (final row in rows) row.uniqueId: row};
  }

  /// Toggle the direction of column order selection.
  @action
  void toggleDirection({
    required FileExplorerTableColumnDefinitionStore colDef,
  }) {
    if (colDef.columnSortIdentifier != null &&
        colDef.columnSortIdentifier == orderBy) {
      switch (orderDir) {
        case OrderDir.asc:
          orderDir = OrderDir.desc;
          break;

        case OrderDir.desc:
          orderDir = OrderDir.none;
          break;

        case null:
        case OrderDir.none:
          orderDir = OrderDir.asc;
          break;
      }
    } else {
      orderDir = OrderDir.asc;
      orderBy = colDef.columnSortIdentifier;
    }
  }

  bool isRowSelected(String uniqueKey) {
    return selectedRows.containsKey(uniqueKey);
  }

  /// A function that returns the row of interest, previous row, and the next row based on the index.
  FileExplorerTableRowEntityGroup getRowValueGroup(int index) {
    final prevIndex = index - 1;
    final nextIndex = index + 1;
    FileExplorerTableRowEntity? prevRow;
    FileExplorerTableRowEntity? nextRow;

    if (isWithinRange(
      value: prevIndex,
      min: 0,
      max: rows.length,
      inclusiveOfMax: false,
    )) {
      prevRow = FileExplorerTableRowEntity(
        rowKey: rows[prevIndex].uniqueId,
        value: rows[prevIndex],
        isSelected: () => isRowSelected(
          rows[prevIndex].uniqueId,
        ),
      );
    }

    if (isWithinRange(
      value: nextIndex,
      min: 0,
      max: rows.length,
      inclusiveOfMax: false,
    )) {
      nextRow = FileExplorerTableRowEntity(
        rowKey: rows[nextIndex].uniqueId,
        value: rows[nextIndex],
        isSelected: () => isRowSelected(
          rows[nextIndex].uniqueId,
        ),
      );
    }

    final row = FileExplorerTableRowEntity(
      rowKey: rows[index].uniqueId,
      value: rows[index],
      isSelected: () => isRowSelected(
        rows[index].uniqueId,
      ),
    );

    return FileExplorerTableRowEntityGroup(
      row: row,
      nextRow: nextRow,
      prevRow: prevRow,
    );
  }
}
