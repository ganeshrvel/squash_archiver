import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/common/exceptions/task_in_progress_exception.dart';
import 'package:squash_archiver/features/home/data/models/archive_data_source_listing_request.dart';
import 'package:squash_archiver/utils/compute_in_background.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

@lazySingleton
class ArchiveDataSource {
  final ArchiverFfi _ffiLib;

  ArchiveDataSource(this._ffiLib);

  @visibleForTesting
  ListArchive cachedListArchiveParams;

  @visibleForTesting
  ListArchiveResult cachedListArchiveResult;

  @visibleForTesting
  int listArchiveCacheResultResetCount = 0;

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

    if (_invalidateCache) {
      _resetListFilesResultsCache();
    }

    DC<Exception, List<FileInfo>> _result;

    if (_skipUsingCache(listArchiveRequest)) {
      // this is purely for testing purposes only
      // the count will be incremented by 1 everytime the cache is invalidated.
      listArchiveCacheResultResetCount += 1;

      /// [listDirectoryPath] should be left empty and [recursive] needs to be true
      /// as we need to fetch the whole file structure
      final _request = listArchiveRequest.copyWith(
        listDirectoryPath: '',
        recursive: true,
      );

      final _param = ArchiveDataSourceListingRequest(
        request: _request,
      );

      final _computedListArchiveResult = await computeInBackground(
        _fetchFiles,
        _param,
      );

      _computedListArchiveResult.pick(
        onError: (error) {
          _result = DC.error(error);

          _resetListFilesResultsCache();
        },
        onData: (data) {
          // caching the results
          cachedListArchiveParams = listArchiveRequest;
          cachedListArchiveResult = data;

          final _filteredPath = _getFilesList(
            listDirectoryPath: listArchiveRequest.listDirectoryPath,
          );

          _result = DC.data(_filteredPath);
        },
        onNoData: () {
          _resetListFilesResultsCache();
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

    if (isNullOrEmpty(cachedListArchiveResult?.files)) {
      return [];
    }

    if (isNull(listDirectoryPath)) {
      return [];
    }

    final _listDirectoryPath = fixDirSlash(
      isDir: true,
      fullPath: listDirectoryPath,
    );

    return cachedListArchiveResult.files.where((file) {
      final _parentPath = fixDirSlash(
        isDir: file.isDir,
        fullPath: file.parentPath,
      );

      return _parentPath == _listDirectoryPath;
    }).toList();
  }

  bool _skipUsingCache(ListArchive params) {
    if (isNull(params) || isNull(cachedListArchiveParams)) {
      return true;
    }

    if (params.filename != cachedListArchiveParams.filename) {
      return true;
    }

    if (params.password != cachedListArchiveParams.password) {
      return true;
    }

    if (params.orderDir != cachedListArchiveParams.orderDir) {
      return true;
    }

    if (params.orderBy != cachedListArchiveParams.orderBy) {
      return true;
    }

    if (!listEquals(
      params.gitIgnorePattern,
      cachedListArchiveParams.gitIgnorePattern,
    )) {
      return true;
    }

    /// making sure that the archive walk through doesn't require a native call
    if (params.listDirectoryPath != cachedListArchiveParams.listDirectoryPath) {
      return false;
    }

    return false;
  }

  void _resetListFilesResultsCache() {
    cachedListArchiveResult = null;
    cachedListArchiveParams = null;
  }
}

Future<DC<Exception, ListArchiveResult>> _fetchFiles(
  ArchiveDataSourceListingRequest params,
) async {
  assert(params != null);

  final _archiverFfi = ArchiverFfi();

  return _archiverFfi.listArchive(params.request);
}
