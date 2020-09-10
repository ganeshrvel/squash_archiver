import 'package:archiver_ffi/archiver_ffi.dart';

void main() {
  final _archiverFfi = ArchiverFfi(isTest: true);

  _archiverFfi.listArchive();
  // _archiverFfi.getUserData();
}
