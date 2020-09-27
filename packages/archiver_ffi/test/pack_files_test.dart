import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/exceptions/file_not_found_exception.dart';
import 'package:archiver_ffi/exceptions/file_not_found_packing_exception.dart';
import 'package:archiver_ffi/models/pack_files.dart';
import 'package:archiver_ffi/utils/test_utils.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  group('Listing an archive', () {
    final _archiverFfi = ArchiverFfi(isTest: true);

    test('should throw (file does not exist) error', () async {
      final _param = PackFiles(
        filename: getTestMocksBuildAsset('mock_test_file1.zip'),
        password: '',
        gitIgnorePattern: [],
        fileList: [
          getTestMocksAsset('mock_dir1'),
          getTestMocksAsset('no_folder'),
        ],
      );

      final _result = await _archiverFfi.packFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundPackingException>());
      expect(_result.error.toString(), contains('no such file or directory'));
    });
  });
}
