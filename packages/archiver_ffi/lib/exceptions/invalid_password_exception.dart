import 'package:archiver_ffi/exceptions/archiver_exception.dart';

class InvalidPasswordException implements ArchiverException {
  @override
  final String error;

  InvalidPasswordException(this.error);

  @override
  String toString() {
    return error;
  }
}
