import 'package:archiver_ffi/src/models/archive_file_info.dart';
import 'package:archiver_ffi/src/utils/functs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum ArchiverOrderBy {
  size,
  modTime,
  name,
  fullPath,
}

enum ArchiverOrderDir {
  asc,
  desc,
  none,
}

// ignore: must_be_immutable
class ListArchive extends Equatable {
  final String filename;
  String password;
  ArchiverOrderBy orderBy;
  ArchiverOrderDir orderDir;
  String listDirectoryPath;
  List<String> gitIgnorePattern;
  bool recursive;

  ListArchive({
    @required this.filename,
    this.password,
    this.orderBy,
    this.orderDir,
    this.listDirectoryPath,
    this.gitIgnorePattern,
    this.recursive,
  }) {
    if (isNullOrEmpty(filename)) {
      throw "archiver_ffi: ListArchive 'filename' cannot be left empty";
    }

    if (isNull(password)) {
      password = '';
    }

    if (isNull(orderBy)) {
      orderBy = ArchiverOrderBy.name;
    }

    if (isNull(orderDir)) {
      orderDir = ArchiverOrderDir.none;
    }

    if (isNullOrEmpty(listDirectoryPath)) {
      listDirectoryPath = '';
    }

    if (isNullOrEmpty(gitIgnorePattern)) {
      gitIgnorePattern = [];
    }

    if (isNull(recursive)) {
      recursive = false;
    }
  }

  @override
  List<Object> get props => [
        filename,
        password,
        orderBy,
        orderDir,
        listDirectoryPath,
        gitIgnorePattern,
        recursive,
      ];
}

class ListArchiveResult extends Equatable {
  final List<ArchiveFileInfo> files;

  final int totalFiles;

  const ListArchiveResult({
    @required this.files,
    @required this.totalFiles,
  });

  @override
  List<Object> get props => [
        files,
        totalFiles,
      ];
}
