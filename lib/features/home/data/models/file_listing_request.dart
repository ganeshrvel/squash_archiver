import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/constants/app_default_values.dart';

class FileListingRequest extends Equatable {
  final String currentPath;

  final String archiveFilePath;

  final String password;

  final OrderBy orderBy;

  final OrderDir orderDir;

  final List<String> gitIgnorePattern;

  const FileListingRequest({
    @required this.currentPath,
    this.archiveFilePath = '',
    this.password = '',
    this.orderBy = AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY,
    this.orderDir = AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR,
    this.gitIgnorePattern = const [],
  });

  @override
  List<Object> get props => [
        currentPath,
        archiveFilePath,
        password,
        orderBy,
        orderDir,
        gitIgnorePattern,
      ];
}
