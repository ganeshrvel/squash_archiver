import 'package:archiver_ffi/exceptions/archiver_exception.dart';

class FilterPathNotFoundException implements ArchiverException {
  @override
  final String error;

  FilterPathNotFoundException(this.error);

  @override
  String toString() {
    return error;
  }
}
