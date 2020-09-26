import 'package:archiver_ffi/utils/functs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PackFiles {
  final String filename;
  String password;
  List<String> gitIgnorePattern;
  List<String> fileList;

  PackFiles({
    @required this.filename,
    this.password,
    this.gitIgnorePattern,
    this.fileList,
  }) {
    if (isNullOrEmpty(filename)) {
      throw "archiver_ffi: 'filename' cannot be left empty";
    }

    if (isNull(password)) {
      password = '';
    }

    if (isNullOrEmpty(gitIgnorePattern)) {
      gitIgnorePattern = [];
    }

    if (isNullOrEmpty(fileList)) {
      fileList = [];
    }
  }
}

class PackFilesResult extends Equatable {
  final bool success;

  const PackFilesResult({
    @required this.success,
  });

  @override
  List<Object> get props => [success];
}
