import 'dart:io';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/utils/utils/files.dart';

@lazySingleton
class LocalDataSource {
  LocalDataSource();

  Future<DC<Exception, List<FileInfo>>> listFiles({
    @required FileListingRequest request,
  }) async {
    assert(request != null);

    final _fileList = <FileInfo>[];

    try {
      final _files = listDirectory(Directory(request.path));

      for (final file in _files) {
        final _name = path.basename(file.path);

        _fileList.add(FileInfo(
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
        ));
      }
    } on Exception catch (e) {
      return DC.error(e);
    }

    return DC.data(_fileList);

    //todo implement sorting and write test case for sorting
  }
}
