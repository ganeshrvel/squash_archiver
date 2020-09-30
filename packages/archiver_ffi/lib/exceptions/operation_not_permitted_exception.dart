import 'package:archiver_ffi/exceptions/archiver_exception.dart';

class OperationNotPermittedException implements ArchiverException {
  @override
  final String error;

  OperationNotPermittedException(this.error);

  @override
  String toString() {
    return error;
  }
}
