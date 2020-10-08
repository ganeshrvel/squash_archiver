import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';

// ignore: must_be_immutable
class FileListingRequest extends Equatable {
  String path;

  String archiveFilename;

  String password;

  OrderBy orderBy;

  OrderDir orderDir;

  List<String> gitIgnorePattern;

  FileExplorerSource source;

  FileListingRequest({
    @required this.path,
    this.archiveFilename,
    this.password,
    this.orderBy,
    this.orderDir,
    this.gitIgnorePattern,
    this.source,
  }) {
    path = path ?? '';
    archiveFilename = archiveFilename ?? '';
    password = password ?? '';
    orderBy = orderBy ?? AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY;
    orderDir = orderDir ?? AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR;
    gitIgnorePattern = gitIgnorePattern ?? [];
    source = source ?? FileExplorerSource.LOCAL;

    assert(path != null);
    assert(archiveFilename != null);
    assert(password != null);
    assert(orderBy != null);
    assert(orderDir != null);
    assert(gitIgnorePattern != null);
    assert(source != null);
  }

  FileListingRequest copyWith({
    String path,
    String archiveFilename,
    String password,
    OrderBy orderBy,
    OrderDir orderDir,
    List<String> gitIgnorePattern,
    FileExplorerSource source,
  }) {
    return FileListingRequest(
      path: path ?? this.path,
      archiveFilename: archiveFilename ?? this.archiveFilename,
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
        archiveFilename,
        password,
        orderBy,
        orderDir,
        gitIgnorePattern,
        source,
      ];
}
