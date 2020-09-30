import 'package:archiver_ffi/exceptions/archiver_exception.dart';

class UnsupportedFileFormatException implements ArchiverException {
  @override
  final String error;

  UnsupportedFileFormatException(this.error);

  @override
  String toString() {
    return error;
  }
}
