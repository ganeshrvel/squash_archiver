import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/foundation.dart';
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
          equals(OrderBy.name));
    });

    test('DEFAULT_FILE_EXPLORER_ORDER_DIR', () async {
      expect(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR,
          equals(OrderDir.asc));
    });

    test('SUPPORTED_ARCHIVE_EXTENSIONS', () async {
      final _supportedArchiveExtns = [];
      AppDefaultValues.SUPPORTED_ARCHIVE_EXTENSIONS.forEach((key, value) {
        _supportedArchiveExtns.add(value);
      });

      expect(
          listEquals(
            _supportedArchiveExtns,
            [
              // todo update 7zip, 7z and tar.zlib and zlib

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
              'xz',
              'sz',
              'lz4',
              'bz2',
              'br',
              'gz',
              'gzip',
              'bzip2',
            ],
          ),
          equals(true));
    });
  });

  test('ALLOWED_SECOND_EXTENSIONS', () async {
    final _allowedArchiveExtns = [];
    AppDefaultValues.ALLOWED_SECOND_EXTENSIONS.forEach((key, value) {
      _allowedArchiveExtns.add(value);
    });

    expect(
        listEquals(
          _allowedArchiveExtns,
          [
            'tar',
          ],
        ),
        equals(true));
  });
}
