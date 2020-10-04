import 'dart:io';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/utils/log/log.dart';
import 'package:squash_archiver/utils/utils/files.dart';

@lazySingleton
class LocalDataSource {
  Future<DC<Exception, List<FileInfo>>> listFiles({
    @required FileListingRequest request,
  }) async {
    assert(request != null);

    final _fileList = <FileInfo>[];

    try {
      final _files = listDirectory(Directory(request.currentPath));

      for (final file in _files) {
        _fileList.add(FileInfo(
          fullPath: file.path,
          //todo fix this
          modTime: file.statSync().modified.toString(),
          parentPath: getParentPath(file.path),
          mode: file.statSync().mode,
          size: file.statSync().size,
          name: basename(file.path),
          isDir: file.statSync().type == FileSystemEntityType.directory,
        ));
      }
    } on Exception catch (e) {
      log.error(title: 'LocalDataSource.listFiles', error: e);

      return DC.error(e);
    }

    return DC.data(_fileList);

    //todo implement sorting and write test case for sorting
  }
}
