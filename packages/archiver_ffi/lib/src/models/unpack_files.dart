import 'package:archiver_ffi/src/utils/functs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// ignore: must_be_immutable
class UnpackFiles extends Equatable {
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

  @override
  List<Object> get props => [
        filename,
        password,
        gitIgnorePattern,
        fileList,
      ];
}

class UnpackFilesResult extends Equatable {
  final bool success;

  const UnpackFilesResult({
    @required this.success,
  });

  UnpackFilesResult copyWith({
    bool success,
  }) {
    return UnpackFilesResult(
      success: success ?? this.success,
    );
  }

  @override
  List<Object> get props => [success];
}
