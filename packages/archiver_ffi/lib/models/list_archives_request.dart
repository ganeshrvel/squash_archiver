import 'package:archiver_ffi/structs/list_archives.dart';
import 'package:archiver_ffi/utils/functs.dart';
import 'package:meta/meta.dart';

class ListArchiveRequest {
  final String filename;
  String password;
  OrderBy orderBy;
  OrderDir orderDir;
  String listDirectoryPath;
  List<String> gitIgnorePattern;
  bool recursive;

  ListArchiveRequest({
    @required this.filename,
    this.password,
    this.orderBy,
    this.orderDir,
    this.listDirectoryPath,
    this.gitIgnorePattern,
    this.recursive,
  }) {
    if (isNullOrEmpty(filename)) {
      throw "archiver_ffi: 'filename' can't be empty";
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
}
