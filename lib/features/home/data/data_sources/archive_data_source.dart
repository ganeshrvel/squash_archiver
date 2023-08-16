import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:collection/collection.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/exceptions/task_in_progress_exception.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/features/home/data/helpers/helpers.dart';
import 'package:squash_archiver/features/home/data/models/archive_data_source_listing_request.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/helpers/files_helper.dart';
import 'package:squash_archiver/utils/compute_in_background.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/hash.dart';

// todo compressed files like: zst xz sz lz4 bz2 br gz ; does not have really real file info for listing. for these files handle that case. sometime if file size is 0, show it as unknown maybe.
// todo the compress files output might need a destination full file path. do not depend on the archive_ffi

@LazySingleton()
class ArchiveDataSource {
  ArchiveDataSource();

  @visibleForTesting
  ListArchive? cachedListArchiveParams;

  @visibleForTesting
  ListArchiveResult? cachedListArchiveResult;

  @visibleForTesting
  int listArchiveCacheResultResetCount = 0;

  /// flag to check if any task is in progress.
  /// spinning up multiple isolates might crash the app, so it's for the best to have a check
  bool taskInProgress = false;

  Future<DC<Exception, List<FileListingResponse>>?> listFiles({
    required ListArchive listArchiveRequest,
    bool invalidateCache = false,
  }) async {
    if (taskInProgress) {
      return DC.error(TaskInProgressException());
    }

    taskInProgress = true;

    if (invalidateCache) {
      _resetListFilesResultsCache();
    }

    DC<Exception, List<FileListingResponse>>? _result;

    if (_fetchFromFfi(listArchiveRequest)) {
      // this is for testing purposes only
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
            listDirectoryPath: listArchiveRequest.listDirectoryPath!,
            orderBy: listArchiveRequest.orderBy,
            orderDir: listArchiveRequest.orderDir,
          );

          _result = DC.data(_filteredPath);
        },
        onNoData: () {
          _resetListFilesResultsCache();
        },
      );
    } else {
      cachedListArchiveParams = listArchiveRequest;

      final _filteredPath = _getFilesList(
        listDirectoryPath: cachedListArchiveParams!.listDirectoryPath!,
        orderBy: cachedListArchiveParams!.orderBy,
        orderDir: cachedListArchiveParams!.orderDir,
      );

      _result = DC.data(_filteredPath);
    }

    taskInProgress = false;

    return _result;
  }

  // filter files by their path
  List<FileListingResponse> _getFilesList({
    required String listDirectoryPath,
    required OrderBy? orderBy,
    required OrderDir? orderDir,
  }) {
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

    var _fileListResult = cachedListArchiveResult!.files.where((file) {
      final _parentPath = fixDirSlash(
        isDir: file.isDir,
        fullPath: file.parentPath,
      );

      if (!AppDefaultValues.SHOW_HIDDEN_FILES) {
        if (file.name.startsWith('.')) {
          return false;
        }
      }

      return _parentPath == _listDirectoryPath;
    }).toList();

    _fileListResult = sortFiles(
      files: _fileListResult,
      orderDir: orderDir,
      orderBy: orderBy,
    );

    return sortFileExplorerEntities(
      files: _fileListResult,
    )
        .mapIndexed(
          (index, file) => FileListingResponse(
            index: index,
            file: file,
            uniqueId: getXxh3(file.fullPath).toString(),
          ),
        )
        .toList();
  }

  bool _fetchFromFfi(ListArchive params) {
    if (isNull(params) || isNull(cachedListArchiveParams)) {
      return true;
    }

    if (params.filename != cachedListArchiveParams!.filename) {
      return true;
    }

    if (params.password != cachedListArchiveParams!.password) {
      return true;
    }

    if (!listEquals(
      params.gitIgnorePattern,
      cachedListArchiveParams!.gitIgnorePattern,
    )) {
      return true;
    }

    /// making sure that the archive walk through doesn't require a native call
    if (params.listDirectoryPath !=
        cachedListArchiveParams!.listDirectoryPath) {
      return false;
    }

    /// if [orderDir] is changed pick it up from cache
    if (params.orderDir != cachedListArchiveParams!.orderDir) {
      return false;
    }

    /// if [orderDir] is changed pick it up from cache
    if (params.orderBy != cachedListArchiveParams!.orderBy) {
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
  String? libAbsPath;
  if (Env.IS_TEST) {
    // this is to assist the unit tests
    // for unit tests we need to supply the absolute path of the library
    libAbsPath = getNativeLib();
  }

  final _archiverFfi = ArchiverFfi(
    libAbsPath: libAbsPath,
  );

  return _archiverFfi.listArchive(params.request);
}
