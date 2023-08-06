import 'package:equatable/equatable.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';

class FileExplorerTableRowsSelection extends Equatable {
  const FileExplorerTableRowsSelection({
    required this.rowKey,
    required this.value,
  });

  final String rowKey;
  final FileListingResponse value;

  @override
  List<Object?> get props => [
        rowKey,
        value,
      ];
}
