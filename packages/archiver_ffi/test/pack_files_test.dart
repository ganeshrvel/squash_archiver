import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/exceptions/file_not_found_to_pack_exception.dart';
import 'package:archiver_ffi/exceptions/file_unsupported_file_format_exception.dart';
import 'package:archiver_ffi/models/list_archive.dart';
import 'package:archiver_ffi/models/pack_files.dart';
import 'package:archiver_ffi/utils/test_utils.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'list_archive_test.dart';

Future<void> _testPackedArchive({
  @required String filename,
  @required ArchiverFfi archiverFfi,
  @required int totalFiles,
  String password,
}) async {
  final _param = ListArchive(
    filename: filename,
    password: password,
    recursive: true,
    listDirectoryPath: '',
    gitIgnorePattern: [],
  );

  final _result = await archiverFfi.listArchive(_param);

  testDataTypesOfArchivedFiles(
    result: _result,
    totalFiles: totalFiles,
  );
}

void main() {
  group('Packing an archive', () {
    final _archiverFfi = ArchiverFfi(isTest: true);

    test('zip | should throw | (no such file or directory) error', () async {
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
      expect(_result.error, isA<FileNotFoundToPackException>());
      expect(_result.error.toString(), contains('no such file or directory'));
    });

    test('wrong extension | should throw | (format unrecognized by filename) error',
        () async {
      final _param = PackFiles(
        filename: getTestMocksBuildAsset('mock_test_file1.test'),
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
      expect(_result.error, isA<UnsupportedFileFormatException>());
      expect(_result.error.toString(), contains('format unrecognized by filename'));
    });

    test('adding files to pack | should not throw error', () async {
      final _filename = getTestMocksBuildAsset('mock_test_file1.zip');

      final _param = PackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: [],
        fileList: [
          getTestMocksAsset('mock_dir1'),
        ],
      );

      final _result = await _archiverFfi.packFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      await _testPackedArchive(
        filename: _filename,
        archiverFfi: _archiverFfi,
        totalFiles: 10,
      );
    });

    test('zip | password | should not throw error', () async {
      final _filename = getTestMocksBuildAsset('mock_enc_test_file1.zip');
      const _password = '1234567';

      final _param = PackFiles(
        filename: _filename,
        password: _password,
        gitIgnorePattern: [],
        fileList: [
          getTestMocksAsset('mock_dir1'),
        ],
      );

      final _result = await _archiverFfi.packFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      await _testPackedArchive(
        filename: _filename,
        archiverFfi: _archiverFfi,
        totalFiles: 10,
        password: _password,
      );
    });

    test("mutliple files in 'fileList' | should not throw error", () async {
      final _filename = getTestMocksBuildAsset('mock_test_file1.zip');

      final _param = PackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: [],
        fileList: [
          getTestMocksAsset('mock_dir1'),
          getTestMocksAsset('mock_dir2'),
        ],
      );

      final _result = await _archiverFfi.packFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      await _testPackedArchive(
        filename: _filename,
        archiverFfi: _archiverFfi,
        totalFiles: 20,
      );
    });

    test("'gitIgnorePattern' | should not throw error", () async {
      final _filename = getTestMocksBuildAsset('mock_test_file1.zip');

      final _param = PackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: ['a.txt'],
        fileList: [
          getTestMocksAsset('mock_dir1'),
        ],
      );

      final _result = await _archiverFfi.packFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      await _testPackedArchive(
        filename: _filename,
        archiverFfi: _archiverFfi,
        totalFiles: 8,
      );
    });

    test('progress | should not throw error', () async {
      final _filename = getTestMocksBuildAsset('mock_test_file1.zip');

      final _param = PackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: [],
        fileList: [
          getTestMocksAsset('mock_dir1'),
        ],
      );

      var _cbCount = 0;
      var _totalFiles = 0;
      var _lastProgressPercentage = 0.0;
      const _progressStep = 10;

      void _packingCb({
        @required String startTime,
        @required String currentFilename,
        @required int totalFiles,
        @required int progressCount,
        @required double progressPercentage,
      }) {
        _cbCount += 1;
        _totalFiles = totalFiles;
        _lastProgressPercentage = progressPercentage;

        expect(startTime, isA<String>());
        expect(currentFilename, isA<String>());
        expect(totalFiles, isA<int>());
        expect(progressCount, isA<int>());
        expect(progressPercentage, isA<double>());

        expect(isDate(startTime), equals(true));
        expect(totalFiles, equals(10));
        expect(
          progressPercentage.toInt(),
          equals(_progressStep * progressCount),
        );

        if (progressCount < totalFiles) {
          expect(currentFilename, contains('/'));
        }
      }

      final _result = await _archiverFfi.packFiles(
        _param,
        onProgress: _packingCb,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));
      expect(_cbCount, greaterThan(_totalFiles));
      expect(_lastProgressPercentage, equals(100.00));

      await _testPackedArchive(
        filename: _filename,
        archiverFfi: _archiverFfi,
        totalFiles: 10,
      );
    });
  });
}
