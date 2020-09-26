import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/models/list_archives_request.dart';
import 'package:archiver_ffi/utils/test_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Listing an archive', () {
    final _archiverFfi = ArchiverFfi(isTest: true);

    test('should throw an error', () async {
      final _param = ListArchiveRequest(
        filename: getTestMocksAsset('no_file.zip'),
        recursive: true,
        listDirectoryPath: '',
        gitIgnorePattern: [],
      );

      final _result = await _archiverFfi.listArchive(_param);

      expect(_result.hasError, equals(true));
      expect(_result.hasData, equals(false));
    });
  });
}
