import 'package:archiver_ffi/src/utils/functs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// ignore: must_be_immutable
class PackFiles extends Equatable {
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
      throw "archiver_ffi: PackFiles 'filename' cannot be left empty";
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

  @override
  List<Object> get props => [
        filename,
        password,
        gitIgnorePattern,
        fileList,
      ];
}

class PackFilesResult extends Equatable {
  final bool success;

  const PackFilesResult({
    @required this.success,
  });

  PackFilesResult copyWith({
    bool success,
  }) {
    return PackFilesResult(
      success: success ?? this.success,
    );
  }

  @override
  List<Object> get props => [success];
}
