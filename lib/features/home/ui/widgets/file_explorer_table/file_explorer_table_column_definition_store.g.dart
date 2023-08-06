// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_explorer_table_column_definition_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FileExplorerTableColumnDefinitionStore
    on _FileExplorerTableColumnDefinitionStoreBase, Store {
  late final _$columnSortIdentifierAtom = Atom(
      name: '_FileExplorerTableColumnDefinitionStoreBase.columnSortIdentifier',
      context: context);

  @override
  OrderBy? get columnSortIdentifier {
    _$columnSortIdentifierAtom.reportRead();
    return super.columnSortIdentifier;
  }

  @override
  set columnSortIdentifier(OrderBy? value) {
    _$columnSortIdentifierAtom.reportWrite(value, super.columnSortIdentifier,
        () {
      super.columnSortIdentifier = value;
    });
  }

  late final _$labelAtom = Atom(
      name: '_FileExplorerTableColumnDefinitionStoreBase.label',
      context: context);

  @override
  String get label {
    _$labelAtom.reportRead();
    return super.label;
  }

  @override
  set label(String value) {
    _$labelAtom.reportWrite(value, super.label, () {
      super.label = value;
    });
  }

  late final _$widthAtom = Atom(
      name: '_FileExplorerTableColumnDefinitionStoreBase.width',
      context: context);

  @override
  TableColumnWidth get width {
    _$widthAtom.reportRead();
    return super.width;
  }

  @override
  set width(TableColumnWidth value) {
    _$widthAtom.reportWrite(value, super.width, () {
      super.width = value;
    });
  }

  @override
  String toString() {
    return '''
columnSortIdentifier: ${columnSortIdentifier},
label: ${label},
width: ${width}
    ''';
  }
}
