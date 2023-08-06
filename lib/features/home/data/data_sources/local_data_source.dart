import 'dart:io';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:dartx/dartx.dart';
import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:squash_archiver/helpers/files_helper.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/helpers/helpers.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/utils/utils/hash.dart';

@LazySingleton()
class LocalDataSource {
  LocalDataSource();

  Future<DC<Exception, List<FileListingResponse>>> listFiles({
    required FileListingRequest request,
  }) async {
    try {
      final _fileListResult = <FileInfo>[];
      final _files = listDirectory(Directory(request.path));

      for (final file in _files) {
        final _name = path.basename(file.path);

        if (!AppDefaultValues.SHOW_HIDDEN_FILES) {
          if (_name.startsWith('.')) {
            continue;
          }
        }

        final _mode = file.statSync().mode;
        final _modeFix = _mode.toRadixString(8).padLeft(4, '0');
        final _modeOctal = _modeFix.substring(_modeFix.length - 4).toInt();

        final _fileInfoResult = FileInfo(
          fullPath: file.path,
          modTime: file.statSync().modified.toString(),
          parentPath: getParentPath(file.path)!,
          mode: _modeOctal,
          size: file.statSync().size,
          name: _name,
          isDir: file.statSync().type == FileSystemEntityType.directory,
          extension: getExtension(_name),
        );

        _fileListResult.add(_fileInfoResult);
      }

      final _fileList = sortFiles(
        files: _fileListResult,
        orderDir: request.orderDir,
        orderBy: request.orderBy,
      );

      final _fileListingResponse = sortFileExplorerEntities(
        files: _fileList,
      )
          .mapIndexed(
            (index, file) => FileListingResponse(
              index: index,
              file: file,
              uniqueId: getXxh3(file.fullPath).toString(),
            ),
          )
          .toList();

      return DC.data(_fileListingResponse);
    } on Exception catch (e) {
      return DC.error(e);
    }
  }
}
