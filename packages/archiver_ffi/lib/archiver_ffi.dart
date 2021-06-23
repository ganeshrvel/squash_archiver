///
/// archiver ffi library
///
library archiver_ffi;

import 'package:archiver_ffi/src/archiver_ffi.dart';
import 'package:archiver_ffi/src/models/list_archive.dart';
import 'package:archiver_ffi/src/utils/test_utils.dart';

export 'package:archiver_ffi/src/archiver_ffi.dart';
export 'package:archiver_ffi/src/exceptions/exceptions.dart';
export 'package:archiver_ffi/src/models/archive_file_info.dart';
export 'package:archiver_ffi/src/models/is_archive_encrypted.dart';
export 'package:archiver_ffi/src/models/list_archive.dart';
export 'package:archiver_ffi/src/models/pack_files.dart';
export 'package:archiver_ffi/src/models/unpack_files.dart';

Future<void> main() async {
  // print('remove this');
  // final _ar = ArchiverFfi(isTest: true);
  //
  // final _param = ListArchive(
  //   filename: getTestMocksAsset('mock_test_file1.zip'),
  //   recursive: true,
  //   listDirectoryPath: '',
  //   //gitIgnorePattern: const ['/a', 'b'],
  // );
  // final _a = await _ar.listArchive(_param);
  //
  // print(_a.data);
}
