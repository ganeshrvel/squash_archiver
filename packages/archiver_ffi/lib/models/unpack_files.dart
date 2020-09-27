import 'package:archiver_ffi/utils/functs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UnpackFiles {
  final String filename;
  final String destination;
  String password;
  List<String> gitIgnorePattern;
  List<String> fileList;

  UnpackFiles({
    @required this.filename,
    @required this.destination,
    this.password,
    this.gitIgnorePattern,
    this.fileList,
  }) {
    if (isNullOrEmpty(filename)) {
      throw "archiver_ffi: UnpackFiles 'filename' cannot be left empty";
    }

    if (isNullOrEmpty(destination)) {
      throw "archiver_ffi: UnpackFiles 'destination' cannot be left empty";
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

class UnpackFilesResult extends Equatable {
  final bool success;

  const UnpackFilesResult({
    @required this.success,
  });

  @override
  List<Object> get props => [success];
}
