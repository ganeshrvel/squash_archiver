// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_explorer_table_datasource_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FileExplorerTableDataSourceStore
    on _FileExplorerTableDataSourceStoreBase, Store {
  Computed<Pair<String, FileListingResponse>?>? _$lastSelectedRowComputed;

  @override
  Pair<String, FileListingResponse>? get lastSelectedRow =>
      (_$lastSelectedRowComputed ??=
              Computed<Pair<String, FileListingResponse>?>(
                  () => super.lastSelectedRow,
                  name:
                      '_FileExplorerTableDataSourceStoreBase.lastSelectedRow'))
          .value;

  late final _$selectedRowsAtom = Atom(
      name: '_FileExplorerTableDataSourceStoreBase.selectedRows',
      context: context);

  @override
  Map<String, FileListingResponse> get selectedRows {
    _$selectedRowsAtom.reportRead();
    return super.selectedRows;
  }

  @override
  set selectedRows(Map<String, FileListingResponse> value) {
    _$selectedRowsAtom.reportWrite(value, super.selectedRows, () {
      super.selectedRows = value;
    });
  }

  late final _$orderDirAtom = Atom(
      name: '_FileExplorerTableDataSourceStoreBase.orderDir', context: context);

  @override
  OrderDir? get orderDir {
    _$orderDirAtom.reportRead();
    return super.orderDir;
  }

  @override
  set orderDir(OrderDir? value) {
    _$orderDirAtom.reportWrite(value, super.orderDir, () {
      super.orderDir = value;
    });
  }

  late final _$orderByAtom = Atom(
      name: '_FileExplorerTableDataSourceStoreBase.orderBy', context: context);

  @override
  OrderBy? get orderBy {
    _$orderByAtom.reportRead();
    return super.orderBy;
  }

  @override
  set orderBy(OrderBy? value) {
    _$orderByAtom.reportWrite(value, super.orderBy, () {
      super.orderBy = value;
    });
  }

  late final _$rowCountAtom = Atom(
      name: '_FileExplorerTableDataSourceStoreBase.rowCount', context: context);

  @override
  int get rowCount {
    _$rowCountAtom.reportRead();
    return super.rowCount;
  }

  @override
  set rowCount(int value) {
    _$rowCountAtom.reportWrite(value, super.rowCount, () {
      super.rowCount = value;
    });
  }

  late final _$colDefsAtom = Atom(
      name: '_FileExplorerTableDataSourceStoreBase.colDefs', context: context);

  @override
  List<FileExplorerTableColumnDefinitionStore> get colDefs {
    _$colDefsAtom.reportRead();
    return super.colDefs;
  }

  @override
  set colDefs(List<FileExplorerTableColumnDefinitionStore> value) {
    _$colDefsAtom.reportWrite(value, super.colDefs, () {
      super.colDefs = value;
    });
  }

  late final _$setOrderDirAsyncAction = AsyncAction(
      '_FileExplorerTableDataSourceStoreBase.setOrderDir',
      context: context);

  @override
  Future<void> setOrderDir(OrderDir? value) {
    return _$setOrderDirAsyncAction.run(() => super.setOrderDir(value));
  }

  late final _$setOrderByAsyncAction = AsyncAction(
      '_FileExplorerTableDataSourceStoreBase.setOrderBy',
      context: context);

  @override
  Future<void> setOrderBy(OrderBy? value) {
    return _$setOrderByAsyncAction.run(() => super.setOrderBy(value));
  }

  late final _$_FileExplorerTableDataSourceStoreBaseActionController =
      ActionController(
          name: '_FileExplorerTableDataSourceStoreBase', context: context);

  @override
  void select(
      {required List<FileExplorerTableRowsSelection> rows,
      required bool append,
      required bool toggleSelection}) {
    final _$actionInfo = _$_FileExplorerTableDataSourceStoreBaseActionController
        .startAction(name: '_FileExplorerTableDataSourceStoreBase.select');
    try {
      return super
          .select(rows: rows, append: append, toggleSelection: toggleSelection);
    } finally {
      _$_FileExplorerTableDataSourceStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_FileExplorerTableDataSourceStoreBaseActionController
        .startAction(name: '_FileExplorerTableDataSourceStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$_FileExplorerTableDataSourceStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void selectAll() {
    final _$actionInfo = _$_FileExplorerTableDataSourceStoreBaseActionController
        .startAction(name: '_FileExplorerTableDataSourceStoreBase.selectAll');
    try {
      return super.selectAll();
    } finally {
      _$_FileExplorerTableDataSourceStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void toggleDirection(
      {required FileExplorerTableColumnDefinitionStore colDef}) {
    final _$actionInfo =
        _$_FileExplorerTableDataSourceStoreBaseActionController.startAction(
            name: '_FileExplorerTableDataSourceStoreBase.toggleDirection');
    try {
      return super.toggleDirection(colDef: colDef);
    } finally {
      _$_FileExplorerTableDataSourceStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedRows: ${selectedRows},
orderDir: ${orderDir},
orderBy: ${orderBy},
rowCount: ${rowCount},
colDefs: ${colDefs},
lastSelectedRow: ${lastSelectedRow}
    ''';
  }
}
