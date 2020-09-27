import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/exceptions/file_not_found_exception.dart';
import 'package:archiver_ffi/models/is_archive_encrypted.dart';
import 'package:archiver_ffi/utils/test_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Is archive encrypted', () {
    final _archiverFfi = ArchiverFfi(isTest: true);

    test('zip | should throw (file does not exist) error', () async {
      final _param = IsArchiveEncrypted(
        filename: getTestMocksAsset('no_file.zip'),
      );

      final _result = await _archiverFfi.isArchiveEncrypted(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('file does not exist'));
    });

    test('tar | should throw (file does not exist) error', () async {
      final _param = IsArchiveEncrypted(
        filename: getTestMocksAsset('no_file.tar'),
      );

      final _result = await _archiverFfi.isArchiveEncrypted(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('file does not exist'));
    });

    test('wrong extension | should throw (file does not exist) error', () async {
      final _param = IsArchiveEncrypted(
        filename: getTestMocksAsset('no_file.tar'),
      );

      final _result = await _archiverFfi.isArchiveEncrypted(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
      expect(_result.error, isA<FileNotFoundException>());
      expect(_result.error.toString(), contains('file does not exist'));
    });

    test('unencrypted file | should not throw an error', () async {
      final _param = IsArchiveEncrypted(
        filename: getTestMocksAsset('mock_test_file1.zip'),
      );

      final _result = await _archiverFfi.isArchiveEncrypted(_param);

      // test the first item in the files list
      expect(_result.data.isEncrypted, equals(false));
      expect(_result.data.isValidPassword, equals(false));
    });

    test('encrypted file | should not throw an error', () async {
      final _param = IsArchiveEncrypted(
        filename: getTestMocksAsset('mock_enc_test_file1.zip'),
      );

      final _result = await _archiverFfi.isArchiveEncrypted(_param);

      // test the first item in the files list
      expect(_result.data.isEncrypted, equals(true));
      expect(_result.data.isValidPassword, equals(false));
    });

    test('encrypted file | invalid password | should not throw an error', () async {
      final _param = IsArchiveEncrypted(
        filename: getTestMocksAsset('mock_enc_test_file1.zip'),
        password: 'qwerty',
      );

      final _result = await _archiverFfi.isArchiveEncrypted(_param);

      // test the first item in the files list
      expect(_result.data.isEncrypted, equals(true));
      expect(_result.data.isValidPassword, equals(false));
    });

    test('encrypted file | valid password | should not throw an error', () async {
      final _param = IsArchiveEncrypted(
        filename: getTestMocksAsset('mock_enc_test_file1.zip'),
        password: '1234567',
      );

      final _result = await _archiverFfi.isArchiveEncrypted(_param);

      // test the first item in the files list
      expect(_result.data.isEncrypted, equals(true));
      expect(_result.data.isValidPassword, equals(true));
    });

    test('encrypted rar file | valid password | should not throw an error', () async {
      final _param = IsArchiveEncrypted(
        filename: getTestMocksAsset('mock_enc_test_file1.rar'),
        password: '1234567',
      );

      final _result = await _archiverFfi.isArchiveEncrypted(_param);

      // test the first item in the files list
      expect(_result.data.isEncrypted, equals(true));
      expect(_result.data.isValidPassword, equals(true));
    });
  });
}
