import 'dart:io';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/helpers.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:dartx/dartx.dart';

@lazySingleton
class LocalDataSource {
  LocalDataSource();

  Future<DC<Exception, List<FileInfo>>> listFiles({
    @required FileListingRequest request,
  }) async {
    assert(request != null);

    var _fileList = <FileInfo>[];

    try {
      final _files = listDirectory(Directory(request.path));

      for (final file in _files) {
        final _name = path.basename(file.path);

        if (!AppDefaultValues.SHOW_HIDDEN_FILES) {
          if (_name.startsWith('.')) {
            continue;
          }
        }

        final _fileInfoResult = FileInfo(
          fullPath: file.path,
          //todo fix this
          modTime: file.statSync().modified.toString(),
          parentPath: getParentPath(file.path),

          //todo fix this
          mode: file.statSync().mode,
          size: file.statSync().size,
          name: _name,
          isDir: file.statSync().type == FileSystemEntityType.directory,
          extension: getExtension(_name),
        );

        _fileList.add(_fileInfoResult);
      }

      _fileList = _sortFiles(
        files: _fileList,
        orderDir: request.orderDir,
        orderBy: request.orderBy,
      );

      _fileList = sortFileExplorerEntities(
        files: _fileList,
      );
    } on Exception catch (e) {
      return DC.error(e);
    }

    return DC.data(_fileList);
  }

  List<FileInfo> _sortFiles({
    @required List<FileInfo> files,
    @required OrderBy orderBy,
    @required OrderDir orderDir,
  }) {
    if (orderDir == OrderDir.none) {
      return files;
    }

    switch (orderBy) {
      case OrderBy.size:
        if (orderDir == OrderDir.asc) {
          return files.sortedBy((file) => file.size);
        }

        return files.sortedByDescending((file) => file.size);

        break;

      case OrderBy.modTime:
        if (orderDir == OrderDir.asc) {
          return files.sortedBy((file) => file.modTime);
        }

        return files.sortedByDescending((file) => file.modTime);

        break;

      case OrderBy.name:
      default:
        if (orderDir == OrderDir.asc) {
          return files.sortedBy((file) => file.name);
        }

        return files.sortedByDescending((file) => file.name);

        break;
    }
  }
}
