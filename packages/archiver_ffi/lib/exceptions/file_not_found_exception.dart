import 'package:archiver_ffi/exceptions/archiver_exception.dart';

class FileNotFoundException implements ArchiverException {
  @override
  final String error;

  FileNotFoundException(this.error);

  @override
  String toString() {
    return error;
  }
}
