import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/data/repositories/file_explorer_repository.dart';

@lazySingleton
class FileExplorerController {
  final FileExplorerRepository _fileExplorerRepository;

  FileExplorerController(
    this._fileExplorerRepository,
  );

  Future<DC<Exception, List<FileInfo>>> listFiles({
    @required FileListingRequest request,
    @required bool invalidateCache,
  }) {
    return _fileExplorerRepository.listFiles(
      request: request,
      invalidateCache: invalidateCache,
    );
  }
}
