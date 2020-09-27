import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/exceptions/file_not_found_packing_exception.dart';
import 'package:archiver_ffi/models/pack_files.dart';
import 'package:archiver_ffi/utils/test_utils.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  group('Listing an archive', () {
    final _archiverFfi = ArchiverFfi(isTest: true);

    test('should throw (no such file or directory) error', () async {
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

    test('progress | should not throw error', () async {
      final _param = PackFiles(
        filename: getTestMocksBuildAsset('mock_test_file1.zip'),
        password: '',
        gitIgnorePattern: [],
        fileList: [
          getTestMocksAsset('mock_dir1'),
        ],
      );

      var _progressCbCount = 0;
      var _totalFiles = 0;

      void _packingCb({
        @required String startTime,
        @required String currentFilename,
        @required int totalFiles,
        @required int progressCount,
        @required double progressPercentage,
      }) {
        _progressCbCount += 1;
        _totalFiles = totalFiles;

        expect(startTime, isA<String>());
        expect(currentFilename, isA<String>());
        expect(totalFiles, isA<int>());
        expect(progressCount, isA<int>());
        expect(progressPercentage, isA<double>());

        expect(isDate(startTime), equals(true));
        expect(totalFiles, equals(10));
      }

      final _result = await _archiverFfi.packFiles(
        _param,
        onProgress: _packingCb,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));
      expect(_progressCbCount, greaterThan(_totalFiles));
    });
  });
}
