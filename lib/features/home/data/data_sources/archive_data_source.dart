import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/exceptions/task_in_progress_exception.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

@lazySingleton
class ArchiveDataSource {
  final ArchiverFfi _ffiLib;

  ArchiveDataSource(this._ffiLib);

  ListArchive _cachedListArchiveParams;

  ListArchiveResult _cachedListArchiveResult;

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
    /// test cases for clear results on error
    /// when cache gets cleared
    /// cases -> file name change, order change, password change etc
    print('todo write test cases for listFiles');

    if (_invalidateCache) {
      _cachedListArchiveParams = null;
      _cachedListArchiveResult = null;
    }

    DC<Exception, List<FileInfo>> _result;

    if (_shouldUseCache(listArchiveRequest)) {
      /// [listDirectoryPath] should be left empty and [recursive] needs to be true
      /// as we need to fetch the whole file structure
      final _request = listArchiveRequest.copyWith(
        listDirectoryPath: '',
        recursive: true,
      );

      final _computedListArchiveResult = await compute(_fetchFiles, _request);

      _computedListArchiveResult.pick(
        onError: (error) {
          _result = DC.error(error);

          _cachedListArchiveResult = null;
          _cachedListArchiveParams = null;
        },
        onData: (data) {
          // caching the results
          _cachedListArchiveParams = listArchiveRequest;
          _cachedListArchiveResult = data;

          final _filteredPath = _getFilesList(
            listDirectoryPath: listArchiveRequest.listDirectoryPath,
          );

          _result = DC.data(_filteredPath);
        },
        onNoData: () {
          _cachedListArchiveResult = null;
          _cachedListArchiveParams = null;
        },
      );
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

    if (isNullOrEmpty(_cachedListArchiveResult?.files)) {
      return [];
    }

    if (isNull(listDirectoryPath)) {
      return [];
    }

    final _listDirectoryPath = fixDirSlash(
      isDir: true,
      fullPath: listDirectoryPath,
    );

    return _cachedListArchiveResult.files.where((file) {
      final _parentPath = fixDirSlash(
        isDir: file.isDir,
        fullPath: file.parentPath,
      );

      return _parentPath == _listDirectoryPath;
    }).toList();
  }

  bool _shouldUseCache(ListArchive params) {
    if (isNull(params) || isNull(_cachedListArchiveParams)) {
      return true;
    }

    if (params.filename != _cachedListArchiveParams.filename) {
      return true;
    }

    if (params.password != _cachedListArchiveParams.password) {
      return true;
    }

    if (params.orderDir != _cachedListArchiveParams.orderDir) {
      return true;
    }

    if (params.orderBy != _cachedListArchiveParams.orderBy) {
      return true;
    }

    if (!listEquals(
      params.gitIgnorePattern,
      _cachedListArchiveParams.gitIgnorePattern,
    )) {
      return true;
    }

    /// making sure that the archive walk through doesn't require a native call
    if (params.listDirectoryPath !=
        _cachedListArchiveParams.listDirectoryPath) {
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
