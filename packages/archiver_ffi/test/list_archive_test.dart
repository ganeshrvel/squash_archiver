import 'package:archiver_ffi/src/archiver_ffi.dart';
import 'package:archiver_ffi/src/exceptions/exceptions.dart';
import 'package:archiver_ffi/src/models/list_archive.dart';
import 'package:archiver_ffi/src/utils/test_utils.dart';
import 'package:data_channel/data_channel.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void testDataTypesOfArchivedFiles({
  @required DC<ArchiverException, ListArchiveResult> result,
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
    expect(item.parentPath, isA<String>());
    expect(item.extension, isA<String>());
    expect(item.modTime, isA<String>());
  }
}

void main() {
  group('Listing an archive', () {
    final _archiverFfi = ArchiverFfi(isTest: true);

    test('zip | should throw (file does not exist) error', () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('no_file.zip'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: const [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('file does not exist'));
    });

    test('tar | should throw (file does not exist) error', () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('no_file.tar'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: const [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('file does not exist'));
    });

    test('wrong extension | should throw (file does not exist) error',
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('no_file.test'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: const [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('file does not exist'));
    });

    test('wrong extension | should throw (file does not exist) error',
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('no_file.zip'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: const [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('file does not exist'));
    });

    test('password required | should throw (file does not exist) error',
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_enc_test_file1.zip'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: const [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<PasswordRequiredException>());
      expect(_result.error.toString(), contains('password is required'));
    });

    test('wrong password | should throw (file does not exist) error', () async {
      final _param = ListArchive(
        password: 'fakepassword',
        filename: getTestMocksAsset('mock_enc_test_file1.zip'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: const [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<InvalidPasswordException>());
      expect(_result.error.toString(), contains('invalid password'));
    });

    test('empty listDirectoryPath | should not throw an error', () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_test_file1.zip'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: const [],
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
      expect(_result.data.files[0].parentPath, equals(''));
      expect(_result.data.files[0].extension, equals(''));
      expect(_result.data.files[0].modTime, equals('2020-08-22T11:45:08.000Z'));
    });

    test("listDirectoryPath='mock_dir1/' | should not throw an error",
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_test_file1.zip'),
        recursive: true,
        listDirectoryPath: 'mock_dir1/',
        gitIgnorePattern: const [],
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
      expect(_result.data.files[0].parentPath, equals('mock_dir1/'));
      expect(_result.data.files[0].extension, equals(''));
      expect(_result.data.files[0].modTime, equals('2020-08-22T11:45:08.000Z'));

      expect(_result.data.files[1].extension, equals('txt'));
    });

    test(
        "recursive=true | listDirectoryPath='mock_dir1/' | should not throw an error",
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_test_file1.zip'),
        recursive: false,
        listDirectoryPath: 'mock_dir1/',
        gitIgnorePattern: const [],
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
      expect(_result.data.files[0].parentPath, equals('mock_dir1/'));
      expect(_result.data.files[0].extension, equals(''));
      expect(_result.data.files[0].modTime, equals('2020-08-22T11:45:08.000Z'));

      expect(_result.data.files[1].extension, equals('txt'));
    });

    test(
        "gitIgnorePattern | listDirectoryPath='mock_dir1/1/' | should not throw an error",
        () async {
      final _param = ListArchive(
        filename: getTestMocksAsset('mock_test_file1.zip'),
        recursive: true,
        listDirectoryPath: 'mock_dir1',
        gitIgnorePattern: const ['mock_dir1/1/'],
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
      expect(_result.data.files[0].parentPath, equals('mock_dir1/'));
      expect(_result.data.files[0].extension, equals('txt'));
      expect(_result.data.files[0].modTime, equals('2020-08-22T11:43:28.000Z'));
    });
  });
}
