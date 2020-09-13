import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/models/list_archives.dart';
import 'package:archiver_ffi/utils/test_utils.dart';

void main() {
  final _archiverFfi = ArchiverFfi(isTest: true);

  final _param = ListArchiver(
    filename: getTestMocksAsset('mock_test_file1.zip'),
  );

  _archiverFfi.listArchive(_param);
}
