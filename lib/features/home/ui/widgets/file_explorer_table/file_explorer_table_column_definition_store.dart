import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:macos_ui/src/library.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';

part 'file_explorer_table_column_definition_store.g.dart';

enum ColumnAlignment {
  start,
  center,
  end,
}

class FileExplorerTableColumnDefinitionStore = _FileExplorerTableColumnDefinitionStoreBase
    with _$FileExplorerTableColumnDefinitionStore;

abstract class _FileExplorerTableColumnDefinitionStoreBase with Store {
  _FileExplorerTableColumnDefinitionStoreBase({
    required this.columnSortIdentifier,
    required this.label,
    required this.width,
    required this.cellBuilder,
    this.alignment = ColumnAlignment.start,
  });

  /// when [columnSortIdentifier] is null then the column sort will be disabled
  @observable
  OrderBy? columnSortIdentifier;

  @observable
  String label;

  @observable
  TableColumnWidth width;

  final ColumnAlignment alignment;

  final Widget Function(BuildContext, FileListingResponse) cellBuilder;
}
