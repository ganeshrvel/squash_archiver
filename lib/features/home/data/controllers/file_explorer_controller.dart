import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/features/home/data/data_sources/archiver_data_source.dart';
import 'package:squash_archiver/features/home/data/data_sources/local_data_source.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';

@lazySingleton
class FileExplorerController {
  final LocalDataSource _localDataSource;
  final ArchiverDataSource _archiverDataSource;

  FileExplorerController(
    this._localDataSource,
    this._archiverDataSource,
  );

  Future<DC<Exception, List<FileInfo>>> listFiles({
    @required FileListingRequest request,
    @required FileExplorerSource source,
    bool invalidateCache,
  }) {
    switch (source) {
      case FileExplorerSource.ARCHIVER:
        final _invalidateCache = invalidateCache ?? false;

        var _currentPath = request.currentPath;

        if (_invalidateCache) {
          // [listDirectoryPath] should be left empty while invalidating the cache to assist the refetch of the whole archive again
          _currentPath = '';
        }

        final _params = ListArchive(
          filename: request.archiveFilePath,
          recursive: true,
          listDirectoryPath: _currentPath,
          password: request.password,
          gitIgnorePattern: request.gitIgnorePattern,
          orderBy: request.orderBy,
          orderDir: request.orderDir,
        );

        return _archiverDataSource.listFiles(
          listArchiveRequest: _params,
          invalidateCache: invalidateCache,
        );

        break;

      case FileExplorerSource.LOCAL:
      default:
        return _localDataSource.listFiles(request: request);

        break;
    }
  }
}
