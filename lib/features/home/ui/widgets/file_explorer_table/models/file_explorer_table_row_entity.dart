import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';

class FileExplorerTableRowEntity {
  const FileExplorerTableRowEntity({
    required this.rowKey,
    required this.value,
    required this.isSelected,
  });

  /// A persistent identifier for this row.
  final String rowKey;

  /// The row value.
  ///
  /// Passed to [rowBuilder] to build a rows cell widgets.
  final FileListingResponse value;

  final bool Function() isSelected;
}

class FileExplorerTableRowEntityGroup {
  const FileExplorerTableRowEntityGroup({
    required this.row,
    this.prevRow,
    this.nextRow,
  });

  /// This row
  final FileExplorerTableRowEntity row;

  /// Previous row
  final FileExplorerTableRowEntity? prevRow;

  /// Next row
  final FileExplorerTableRowEntity? nextRow;
}
