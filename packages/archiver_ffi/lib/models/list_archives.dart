import 'package:archiver_ffi/structs/list_archives.dart';
import 'package:archiver_ffi/utils/functs.dart';
import 'package:meta/meta.dart';

class ListArchiver {
  String filename;
  String password;
  OrderBy orderBy;
  OrderDir orderDir;
  String listDirectoryPath;
  List<String> gitIgnorePattern;
  bool recursive;

  ListArchiver({
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
      this.password = '';
    }

    if (isNull(orderBy)) {
      this.orderBy = OrderBy.name;
    }

    if (isNull(orderDir)) {
      this.orderDir = OrderDir.none;
    }

    if (isNullOrEmpty(listDirectoryPath)) {
      this.listDirectoryPath = '';
    }

    if (isNullOrEmpty(gitIgnorePattern)) {
      this.gitIgnorePattern = [];
    }

    if (isNull(recursive)) {
      this.recursive = false;
    }
  }
}
