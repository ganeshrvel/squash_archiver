import 'package:archiver_ffi/models/archive_file_info.dart';
import 'package:archiver_ffi/structs/list_archive.dart';
import 'package:archiver_ffi/utils/functs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// ignore: must_be_immutable
class ListArchive extends Equatable {
  final String filename;
  String password;
  OrderBy orderBy;
  OrderDir orderDir;
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
      orderBy = OrderBy.name;
    }

    if (isNull(orderDir)) {
      orderDir = OrderDir.none;
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
