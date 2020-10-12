import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_entities_sort_by.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

List<FileInfo> sortFileExplorerEntities({
  @required List<FileInfo> files,
}) {
  if (AppDefaultValues.DEFAULT_FILE_EXPLORER_ENTITIES_SORT_BY ==
      FileExplorerEntitiesSortBy.none) {
    return files;
  }

  if (isNullOrEmpty(files)) {
    return files;
  }

  final _folderBucket = <FileInfo>[];
  final _fileBucket = <FileInfo>[];
  final _sortedFiles = <FileInfo>[];

  files.forEach((file) {
    if (file.isDir) {
      _folderBucket.add(file);
    } else {
      _fileBucket.add(file);
    }
  });

  switch (AppDefaultValues.DEFAULT_FILE_EXPLORER_ENTITIES_SORT_BY) {
    case FileExplorerEntitiesSortBy.file:
      // preserve the order
      _sortedFiles.addAll(_fileBucket);
      _sortedFiles.addAll(_folderBucket);

      return _sortedFiles;

      break;
    case FileExplorerEntitiesSortBy.directory:
    default:
      // preserve the order
      _sortedFiles.addAll(_folderBucket);
      _sortedFiles.addAll(_fileBucket);

      return _sortedFiles;

      break;
  }
}
