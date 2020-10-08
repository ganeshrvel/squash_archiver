import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/exceptions/task_in_progress_exception.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

@lazySingleton
class ArchiverDataSource {
  final ArchiverFfi _ffiLib;

  ArchiverDataSource(this._ffiLib);

  ListArchive _listArchiveParams;

  ListArchiveResult _listArchiveResult;

  /// flag to check if any task is in progress.
  /// spinning up multiple isolates might crash the app, so it's for the best to have a check
  bool taskInProgress = false;

  Future<DC<Exception, List<FileInfo>>> listFiles({
    @required ListArchive listArchiveRequest,
    bool invalidateCache,
  }) async {
    assert(listArchiveRequest != null);

    if (taskInProgress) {
      return DC.error(TaskInProgressException());
    }

    taskInProgress = true;

    final _invalidateCache = invalidateCache ?? false;

    /// todo write test cases for listFiles
    print('todo write test cases for listFiles');

    if (_invalidateCache) {
      _listArchiveParams = null;
      _listArchiveResult = null;
    }

    DC<Exception, List<FileInfo>> _result;

    if (_shouldUseCache(listArchiveRequest)) {
      // caching the results
      _listArchiveParams = listArchiveRequest;

      /// [listDirectoryPath] should be left empty and [recursive] needs to be true
      /// as we need to fetch the whole file structure
      final _request = listArchiveRequest.copyWith(
        listDirectoryPath: '',
        recursive: true,
      );

      final _computedListArchiveResult = await compute(_fetchFiles, _request);

      if (_computedListArchiveResult.hasError) {
        _result = DC.error(_computedListArchiveResult.error);
      } else if (_computedListArchiveResult.hasData) {
        _listArchiveResult = _computedListArchiveResult.data;

        final _filteredPath = _getFilesList(
          listDirectoryPath: listArchiveRequest.listDirectoryPath,
        );

        _result = DC.data(_filteredPath);
      }
    } else {
      final _filteredPath = _getFilesList(
        listDirectoryPath: listArchiveRequest.listDirectoryPath,
      );

      _result = DC.data(_filteredPath);
    }

    taskInProgress = false;

    return _result;
  }

  // filter files by their path
  List<FileInfo> _getFilesList({
    @required String listDirectoryPath,
  }) {
    assert(listDirectoryPath != null);

    if (isNullOrEmpty(_listArchiveResult.files)) {
      return [];
    }

    if (isNull(listDirectoryPath)) {
      return [];
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

  bool _shouldUseCache(ListArchive params) {
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

Future<DC<Exception, ListArchiveResult>> _fetchFiles(
  ListArchive params,
) async {
  final _archiverFfi = ArchiverFfi();

  return _archiverFfi.listArchive(params);
}
