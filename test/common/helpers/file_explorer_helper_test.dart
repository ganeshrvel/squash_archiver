import 'package:flutter_test/flutter_test.dart';
import 'package:squash_archiver/common/helpers/archive_helper.dart';

void main() {
  group('file_explorer_helper', () {
    group('isArchiveFormatSupported', () {
      test('should return true', () async {
        final _supportedList = [
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
        ];

        _supportedList.forEach((ext) {
          expect(
            isArchiveFormatSupported(ext),
            equals(true),
            reason: 'failure: $ext',
          );
        });
      });

      test('should return false', () async {
        final _supportedList = [
          '.zip',
          '.tar',
          '.tar.br',
          '.tar.bz2',
          '.tar.gz',
          '.tar.lz4',
          '.tar.sz',
          '.tar.xz',
          '.tar.zst',
          '.rar',
          'gz',
          '.gz',
          '',
          '.',
        ];

        _supportedList.forEach((ext) {
          expect(
            isArchiveFormatSupported(ext),
            equals(false),
            reason: 'failure: $ext',
          );
        });
      });
    });
  });
}
