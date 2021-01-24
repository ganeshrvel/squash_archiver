import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' show basename;
import 'package:meta/meta.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';

// ignore: must_be_immutable
class FileListingRequest extends Equatable {
  /// path to the directory to list files
  String path;

  /// only used for listing archives
  /// the full path to the archive file
  String archiveFilepath;

  String password;

  OrderBy orderBy;

  OrderDir orderDir;

  List<String> gitIgnorePattern;

  FileExplorerSource source;

  /// file name derived from [archiveFilepath]
  String get filename => basename(archiveFilepath);

  FileListingRequest({
    @required this.path,
    this.archiveFilepath,
    this.password,
    this.orderBy,
    this.orderDir,
    this.gitIgnorePattern,
    this.source,
  }) {
    path = path ?? '';
    archiveFilepath = archiveFilepath ?? '';
    password = password ?? '';
    orderBy = orderBy ?? AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY;
    orderDir = orderDir ?? AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR;
    gitIgnorePattern = gitIgnorePattern ?? [];
    source = source ?? FileExplorerSource.LOCAL;

    assert(path != null);
    assert(archiveFilepath != null);
    assert(password != null);
    assert(orderBy != null);
    assert(orderDir != null);
    assert(gitIgnorePattern != null);
    assert(source != null);

    if (orderBy == OrderBy.fullPath) {
      throw "'orderBy.fullPath' isn't supported";
    }
  }

  FileListingRequest copyWith({
    String path,
    String archiveFilepath,
    String password,
    OrderBy orderBy,
    OrderDir orderDir,
    List<String> gitIgnorePattern,
    FileExplorerSource source,
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
