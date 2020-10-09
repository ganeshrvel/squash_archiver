import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/utils/utils/files.dart';

void main() {
  group('AppDefaultValues', () {
    test('DEFAULT_FILE_EXPLORER_DIRECTORY', () async {
      expect(AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
          equals(homeDirectory()));
    });

    test('DEFAULT_FILE_EXPLORER_ORDER_BY', () async {
      expect(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY,
          equals(OrderBy.fullPath));
    });

    test('DEFAULT_FILE_EXPLORER_ORDER_DIR', () async {
      expect(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR,
          equals(OrderDir.none));
    });

    test('SUPPORTED_ARCHIVE_EXTENSIONS', () async {
      expect(
        AppDefaultValues.SUPPORTED_ARCHIVE_EXTENSIONS,
        containsAllInOrder([
          'zip',
          'tar',
          'tar.br',
          'tar.bz2',
          'tar.gz',
          'tar.lz4',
          'tar.sz',
          'tar.xz',
          'tar.zst',
          'rar',
        ]),
      );
    });
  });
}
