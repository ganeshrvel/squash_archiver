import 'package:archiver_ffi/src/utils/functs.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class IsArchiveEncrypted extends Equatable {
  final String filename;
  String? password;

  IsArchiveEncrypted({
    required this.filename,
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
  List<Object?> get props => [
        filename,
        password,
      ];

  @override
  String toString() {
    super.toString();

    return '''
        filename: $filename,
        password: $password,
        ''';
  }
}

class IsArchiveEncryptedResult extends Equatable {
  final bool isEncrypted;
  final bool isValidPassword;

  const IsArchiveEncryptedResult({
    required this.isEncrypted,
    required this.isValidPassword,
  });

  IsArchiveEncryptedResult copyWith({
    bool? isEncrypted,
    bool? isValidPassword,
  }) {
    return IsArchiveEncryptedResult(
      isEncrypted: isEncrypted ?? this.isEncrypted,
      isValidPassword: isValidPassword ?? this.isValidPassword,
    );
  }

  @override
  List<Object> get props => [
        isEncrypted,
        isValidPassword,
      ];

  @override
  String toString() {
    super.toString();

    return '''
        isEncrypted: $isEncrypted,
        isValidPassword: $isValidPassword,
        ''';
  }
}
