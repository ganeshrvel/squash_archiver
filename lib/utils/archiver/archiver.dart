import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/exceptions/archiver_exception.dart';
import 'package:archiver_ffi/models/archive_file_info.dart';
import 'package:archiver_ffi/models/list_archive.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/utils/archiver/archiver_provider.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

@lazySingleton
class Archiver {
  final ArchiverFfi _ffiLib =
      archiverFfiProviderContainer.read(archiverFfiProvider);

  ListArchive _listArchiveParams;

  ListArchiveResult _listArchiveResult;

  Future<DC<ArchiverException, List<ArchiveFileInfo>>> listFiles(
    ListArchive params,
  ) async {
    assert(params != null);

    DC<ArchiverException, ListArchiveResult> _result;

    if (_useCache(params)) {
      // caching the results
      _listArchiveParams = params;

      _result = await compute(_fetchFiles, params);

      if (_result.hasError) {
        return DC.error(_result.error);
      }

      if (_result.hasData) {
        _listArchiveResult = _result.data;

        final _filteredPath = _getFilesList(
          listDirectoryPath: params.listDirectoryPath,
        );

        return DC.data(_filteredPath);
      }
    } else {
      final _filteredPath = _getFilesList(
        listDirectoryPath: params.listDirectoryPath,
      );

      return DC.data(_filteredPath);
    }

    // todo calculate and return value back

    return DC.data([]);
  }

  // filter files by their path
  List<ArchiveFileInfo> _getFilesList({
    @required String listDirectoryPath,
  }) {
    assert(listDirectoryPath != null);

    if (isNullOrEmpty(_listArchiveResult.files)) {
      return [];
    }

    if (isNullOrEmpty(listDirectoryPath)) {
      return _listArchiveResult.files;
    }

    final _listDirectoryPath = fixDirSlash(
      isDir: true,
      fullPath: listDirectoryPath,
    );

    return _listArchiveResult.files.where((file) {
      final _parentPath = fixDirSlash(
        isDir: file.isDir,
        fullPath: file.parentPath,
      );

      return _parentPath == _listDirectoryPath;
    }).toList();
  }

  bool _useCache(ListArchive params) {
    if (isNull(params) || isNull(_listArchiveParams)) {
      return true;
    }

    if (params.filename != _listArchiveParams.filename) {
      return true;
    }

    if (params.password != _listArchiveParams.password) {
      return true;
    }

    if (params.orderDir != _listArchiveParams.orderDir) {
      return true;
    }

    if (params.orderBy != _listArchiveParams.orderBy) {
      return true;
    }

    if (params.recursive != _listArchiveParams.recursive) {
      return true;
    }

    if (!listEquals(
      params.gitIgnorePattern,
      _listArchiveParams.gitIgnorePattern,
    )) {
      return true;
    }

    /// making sure that the archive walk through doesn't require a native call
    if (params.listDirectoryPath != _listArchiveParams.listDirectoryPath) {
      return false;
    }

    return false;
  }
}

Future<DC<ArchiverException, ListArchiveResult>> _fetchFiles(
  ListArchive params,
) async {
  final _ffiLib = archiverFfiProviderContainer.read(archiverFfiProvider);

  return _ffiLib.listArchive(params);
}
