import 'package:archiver_ffi/utils/functs.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class IsArchiveEncrypted {
  final String filename;
  String password;

  IsArchiveEncrypted({
    @required this.filename,
    this.password,
  }) {
    if (isNullOrEmpty(filename)) {
      throw "archiver_ffi: 'filename' cannot be left empty";
    }

    if (isNull(password)) {
      password = '';
    }
  }
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
