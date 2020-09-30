import 'package:archiver_ffi/utils/functs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// ignore: must_be_immutable
class IsArchiveEncrypted extends Equatable {
  final String filename;
  String password;

  IsArchiveEncrypted({
    @required this.filename,
    this.password,
  }) {
    if (isNullOrEmpty(filename)) {
      throw "archiver_ffi: IsArchiveEncrypted 'filename' cannot be left empty";
    }

    if (isNull(password)) {
      password = '';
    }
  }

  @override
  List<Object> get props => [
        filename,
        password,
      ];
}

class IsArchiveEncryptedResult extends Equatable {
  final bool isEncrypted;
  final bool isValidPassword;

  const IsArchiveEncryptedResult({
    @required this.isEncrypted,
    @required this.isValidPassword,
  });

  @override
  List<Object> get props => [
        isEncrypted,
        isValidPassword,
      ];
}
