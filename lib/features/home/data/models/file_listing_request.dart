import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' show basename;

import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';

class FileListingRequest extends Equatable {
  /// path to the directory to list files
  final String path;

  /// only used for listing archives
  /// the full path to the archive file
  late final String archiveFilepath;

  late final String password;

  late final OrderBy orderBy;

  late final OrderDir orderDir;

  late final List<String> gitIgnorePattern;

  late final FileExplorerSource source;

  /// file name derived from [archiveFilepath]
  String get filename => basename(archiveFilepath);

  FileListingRequest({
    required this.path,
    String? archiveFilepath,
    String? password,
    OrderBy? orderBy,
    OrderDir? orderDir,
    List<String>? gitIgnorePattern,
    FileExplorerSource? source,
  }) {
    this.archiveFilepath = archiveFilepath ?? '';
    this.password = password ?? '';
    this.orderBy = orderBy ?? AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY;
    this.orderDir =
        orderDir ?? AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR;
    this.gitIgnorePattern = gitIgnorePattern ?? [];
    this.source = source ?? FileExplorerSource.LOCAL;

    if (orderBy == OrderBy.fullPath) {
      throw "'orderBy.fullPath' isn't supported";
    }
  }

  FileListingRequest copyWith({
    String? path,
    String? archiveFilepath,
    String? password,
    OrderBy? orderBy,
    OrderDir? orderDir,
    List<String>? gitIgnorePattern,
    FileExplorerSource? source,
  }) {
    return FileListingRequest(
      path: path ?? this.path,
      archiveFilepath: archiveFilepath ?? this.archiveFilepath,
      password: password ?? this.password,
      orderBy: orderBy ?? this.orderBy,
      orderDir: orderDir ?? this.orderDir,
      gitIgnorePattern: gitIgnorePattern ?? this.gitIgnorePattern,
      source: source ?? this.source,
    );
  }

  @override
  List<Object> get props => [
        path,
        archiveFilepath,
        password,
        orderBy,
        orderDir,
        gitIgnorePattern,
        source,
      ];
}
