import 'package:archiver_ffi/exceptions/archiver_exception.dart';

class FileNotFoundToPackException implements ArchiverException {
  @override
  final String error;

  FileNotFoundToPackException(this.error);

  @override
  String toString() {
    return error;
  }
}
