import 'dart:io';

import 'package:archiver_ffi/src/archiver_ffi.dart';
import 'package:archiver_ffi/src/exceptions/exceptions.dart';
import 'package:archiver_ffi/src/models/unpack_files.dart';
import 'package:archiver_ffi/src/utils/test_utils.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  group('Unpacking an archive', () {
    final _archiverFfi = ArchiverFfi(isTest: true);

    test('zip | should throw (no such file or directory) error', () async {
      final _param = UnpackFiles(
        filename: getTestMocksAsset('to_file.zip'),
        password: '',
        destination: getTestMocksBuildAsset('mock_test_file1', isDir: true),
        gitIgnorePattern: [],
        fileList: [],
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('no such file or directory'));
    });

    test('tar | should throw (no such file or directory) error', () async {
      final _param = UnpackFiles(
        filename: getTestMocksAsset('to_file.tar'),
        password: '',
        destination: getTestMocksBuildAsset('mock_test_file1', isDir: true),
        gitIgnorePattern: [],
        fileList: [],
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('no such file or directory'));
    });

    test('wrong extension | should throw (no such file or directory) error',
        () async {
      final _param = UnpackFiles(
        filename: getTestMocksAsset('to_file.test'),
        password: '',
        destination: getTestMocksBuildAsset('mock_test_file1', isDir: true),
        gitIgnorePattern: [],
        fileList: [],
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<UnsupportedFileFormatException>());
      expect(_result.error.toString(),
          contains('format unrecognized by filename'));
    });

    test('wrong password | should throw (file does not exist) error', () async {
      final _param = UnpackFiles(
        filename: getTestMocksAsset('mock_enc_test_file1.zip'),
        destination: getTestMocksBuildAsset('mock_test_file1', isDir: true),
        gitIgnorePattern: [],
      );

      final _result = await _archiverFfi.unpackFiles(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<InvalidPasswordException>());
      expect(_result.error.toString(), contains('invalid password'));
    });

    test('adding files to unpack | should not throw error', () async {
      final _filename = getTestMocksAsset('mock_test_file1.zip');
      final _destination =
          getTestMocksBuildAsset('mock_test_file1', isDir: true);

      final _param = UnpackFiles(
        filename: _filename,
        gitIgnorePattern: [],
        fileList: [],
        destination: _destination,
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      final _files = await dirContents(Directory(_destination));
      expect(_files.length, 10);
    });

    test('password | zip | should not throw error', () async {
      final _filename = getTestMocksAsset('mock_enc_test_file1.zip');
      const _password = '1234567';
      final _destination =
          getTestMocksBuildAsset('mock_test_file1', isDir: true);

      final _param = UnpackFiles(
        filename: _filename,
        password: _password,
        gitIgnorePattern: [],
        fileList: [],
        destination: _destination,
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      final _files = await dirContents(Directory(_destination));
      expect(_files.length, 10);
    });

    test("single files in 'fileList' | should not throw error", () async {
      final _filename = getTestMocksAsset('mock_test_file1.zip');
      final _destination =
          getTestMocksBuildAsset('mock_test_file1', isDir: true);

      final _param = UnpackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: [],
        fileList: ['mock_dir1/1'],
        destination: _destination,
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      final _files = await dirContents(Directory(_destination));
      expect(_files.length, 3);
    });

    test("mutliple files in 'fileList' | should not throw error", () async {
      final _filename = getTestMocksAsset('mock_test_file1.zip');
      final _destination =
          getTestMocksBuildAsset('mock_test_file1', isDir: true);

      final _param = UnpackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: [],
        fileList: [
          'mock_dir1/1',
          'mock_dir1/2',
        ],
        destination: _destination,
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      final _files = await dirContents(Directory(_destination));
      expect(_files.length, 5);
    });

    test("invalid path in 'fileList' | should not throw error", () async {
      final _filename = getTestMocksAsset('mock_test_file1.zip');
      final _destination =
          getTestMocksBuildAsset('mock_test_file1', isDir: true);

      final _param = UnpackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: [],
        fileList: [
          'dummy/path/mock_dir1/1',
        ],
        destination: _destination,
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      final _files = await dirContents(Directory(_destination));
      expect(_files.length, 0);
    });

    test("'gitIgnorePattern' | should not throw error", () async {
      final _filename = getTestMocksAsset('mock_test_file1.zip');
      final _destination =
          getTestMocksBuildAsset('mock_test_file1', isDir: true);

      final _param = UnpackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: ['a.txt'],
        fileList: [],
        destination: _destination,
      );

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: null,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));

      final _files = await dirContents(Directory(_destination));
      expect(_files.length, 8);
    });

    test('progress | should not throw error', () async {
      final _filename = getTestMocksAsset('mock_test_file1.zip');
      final _destination =
          getTestMocksBuildAsset('mock_test_file1', isDir: true);

      final _param = UnpackFiles(
        filename: _filename,
        password: '',
        gitIgnorePattern: [],
        fileList: [],
        destination: _destination,
      );

      var _cbCount = 0;
      var _totalFiles = 0;
      var _lastProgressPercentage = 0.0;
      const _progressStep = 10;

      void _unpackingCb({
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

      final _result = await _archiverFfi.unpackFiles(
        _param,
        onProgress: _unpackingCb,
      );

      expect(_result.hasError, equals(false));
      expect(_result.hasData, equals(true));
      expect(_cbCount, greaterThan(_totalFiles));
      expect(_lastProgressPercentage, equals(100.00));

      final _files = await dirContents(Directory(_destination));
      expect(_files.length, 10);
    });
  });
}
