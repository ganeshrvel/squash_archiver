import 'dart:async';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';

import 'package:squash_archiver/features/home/data/data_sources/archive_data_source.dart';
import 'package:squash_archiver/features/home/data/data_sources/local_data_source.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/utils/error_handling/handle_exception.dart';

@LazySingleton()
class FileExplorerRepository {
  final LocalDataSource _localDataSource;
  final ArchiveDataSource _archiveDataSource;

  FileExplorerRepository(
    this._localDataSource,
    this._archiveDataSource,
  );

  Future<DC<Exception, List<FileListingResponse>>> listFiles({
    required FileListingRequest request,
    bool invalidateCache = false,
  }) async {
    switch (request.source) {
      case FileExplorerSource.ARCHIVE:
        try {
          final _params = ListArchive(
            filename: request.archiveFilepath!,
            listDirectoryPath: request.path,
            password: request.password,
            gitIgnorePattern: request.gitIgnorePattern,
            orderBy: request.orderBy,
            orderDir: request.orderDir,
          );

          final _result = await (_archiveDataSource.listFiles(
            listArchiveRequest: _params,
            invalidateCache: invalidateCache,
          ) as FutureOr<DC<Exception, List<FileListingResponse>>>);

          if (_result.hasError) {
            handleException(
              _result.error,
              allowLogging: true,
              stackTrace: null,
            );
          }

          return _result;
        } on Exception catch (e, stackTrace) {
          handleException(e, allowLogging: true, stackTrace: stackTrace);

          return DC.error(e);
        }

      case FileExplorerSource.LOCAL:
      default:
        try {
          final _result = await _localDataSource.listFiles(request: request);

          if (_result.hasError) {
            handleException(
              _result.error,
              allowLogging: true,
              stackTrace: null,
            );
          }

          return _result;
        } on Exception catch (e, stackTrace) {
          handleException(e, allowLogging: true, stackTrace: stackTrace);

          return DC.error(e);
        }
    }
  }
}
