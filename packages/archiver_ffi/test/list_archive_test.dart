import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/exceptions/file_not_found_exception.dart';
import 'package:archiver_ffi/models/list_archive.dart';
import 'package:archiver_ffi/utils/test_utils.dart';
import 'package:data_channel/data_channel.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void testDataTypesOfArchivedFiles({
  @required DC<Exception, ListArchiveResult> result,
  @required int totalFiles,
}) {
  expect(result.hasError, equals(false));
  expect(result.hasData, equals(true));
  expect(result.error, null);
  expect(result.data, isA<ListArchiveResult>());
  expect(result.data.totalFiles, totalFiles);
  expect(result.data.files, hasLength(totalFiles));

  for (var i = 0; i < result.data.files.length; i++) {
    final item = result.data.files[i];

    expect(item.size, isA<int>());
    expect(item.name, isA<String>());
    expect(item.isDir, isA<bool>());
    expect(item.mode, isA<int>());
    expect(item.fullPath, isA<String>());
    expect(item.modTime, isA<String>());
  }
}

void main() {
  group('Listing an archive', () {
    final _archiverFfi = ArchiverFfi(isTest: true);

    test('should throw (file does not exist) error', () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('no_file.zip'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('file does not exist'));
    });

    test('empty listDirectoryPath | should not throw an error', () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_test_file1.zip'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      testDataTypesOfArchivedFiles(
        result: _result,
        totalFiles: 10,
      );

      // test the first item in the files list
      expect(_result.data.files[0].size, equals(0));
      expect(_result.data.files[0].name, equals('mock_dir1'));
      expect(_result.data.files[0].isDir, equals(true));
      expect(_result.data.files[0].mode, equals(755));
      expect(_result.data.files[0].fullPath, equals('mock_dir1/'));
      expect(_result.data.files[0].modTime,
          equals('2020-08-22T11:45:08.000Z'));
    });

    test("listDirectoryPath='mock_dir1/' | should not throw an error",
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_test_file1.zip'),
        recursive: true,
        listDirectoryPath: 'mock_dir1/',
        gitIgnorePattern: [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      testDataTypesOfArchivedFiles(
        result: _result,
        totalFiles: 9,
      );

      // test the first item in the files list
      expect(_result.data.files[0].size, equals(0));
      expect(_result.data.files[0].name, equals('1'));
      expect(_result.data.files[0].isDir, equals(true));
      expect(_result.data.files[0].mode, equals(755));
      expect(_result.data.files[0].fullPath, equals('mock_dir1/1/'));
      expect(_result.data.files[0].modTime,
          equals('2020-08-22T11:45:08.000Z'));
    });

    test(
        "recursive=true | listDirectoryPath='mock_dir1/' | should not throw an error",
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_test_file1.zip'),
        recursive: false,
        listDirectoryPath: 'mock_dir1/',
        gitIgnorePattern: [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      testDataTypesOfArchivedFiles(
        result: _result,
        totalFiles: 4,
      );

      // test the first item in the files list
      expect(_result.data.files[0].size, equals(0));
      expect(_result.data.files[0].name, equals('1'));
      expect(_result.data.files[0].isDir, equals(true));
      expect(_result.data.files[0].mode, equals(755));
      expect(_result.data.files[0].fullPath, equals('mock_dir1/1/'));
      expect(_result.data.files[0].modTime,
          equals('2020-08-22T11:45:08.000Z'));
    });

    test(
        "gitIgnorePattern | listDirectoryPath='mock_dir1/1/' | should not throw an error",
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_test_file1.zip'),
        recursive: true,
        listDirectoryPath: 'mock_dir1',
        gitIgnorePattern: ['mock_dir1/1/'],
      );

      final _result = await _archiverFfi.listArchive(_param);

      testDataTypesOfArchivedFiles(
        result: _result,
        totalFiles: 7,
      );

      // test the first item in the files list
      expect(_result.data.files[0].size, equals(9));
      expect(_result.data.files[0].name, equals('a.txt'));
      expect(_result.data.files[0].isDir, equals(false));
      expect(_result.data.files[0].mode, equals(644));
      expect(_result.data.files[0].fullPath, equals('mock_dir1/a.txt'));
      expect(_result.data.files[0].modTime,
          equals('2020-08-22T11:43:28.000Z'));
    });
  });
}
