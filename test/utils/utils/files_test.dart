import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/common/models/truncated_filename.dart';
import 'package:squash_archiver/utils/utils/files.dart';

class _TestFixDirSlash {
  final bool isDir;
  final String fullPath;
  final String processedPath;

  _TestFixDirSlash({
    @required this.isDir,
    @required this.fullPath,
    @required this.processedPath,
  });
}

void main() {
  test('getExtension', () async {
    const _mediaMap = {
      '': '',
      'abc.xyz.tar.gz': 'tar.gz',
      'abc.xyz.tar.tar': 'tar.tar',
      'xyz.tar.gz': 'tar.gz',
      'tar.gz': 'gz',
      'abc.gz': 'gz',
      '.gz': 'gz',
      '.tar': 'tar',
      '.tar.gz': 'tar.gz',
      'tar.tar.gz': 'tar.gz',
      '.htaccess': 'htaccess',
      'abc.txt': 'txt',
      'abc': '',
      'github.com/ganeshrvel/one-archiver/e2e_list_test.go': 'go',
      'one-archiver/e2e_list_test.go': 'go',
      'e2e_list_test.go/.go.psd': 'psd',
      'file.jpg': 'jpg',
      'file.rar': 'rar',
      'file.tar.gz': 'tar.gz',
      'file.12': '12',
      'path/to/file.23': '23',
      'path/to/123.file.23': '23',
      'path/to/.123.file.23': '23',
      'path/to/.123...23': '23',
      'path/to/file.tar.34': 'tar.34',
      'path/to.get/file.tar.56': 'tar.56',
      'path/to/file./78': '',
      'path/to/file./.89': '89',
      'qwerty': '',
      '..htaccess': 'htaccess',
      '.': '',
      null: '',
      ' ': '',
      ' . ': ' ',
    };

    for (final item in _mediaMap.entries) {
      expect(
        getExtension(item.key),
        equals(item.value),
        reason: 'failure: ${item.key.toString()}',
      );
    }
  });

  test('fixDirSlash', () async {
    final _testData = [
      _TestFixDirSlash(
        fullPath: 'file.jpg',
        isDir: false,
        processedPath: 'file.jpg',
      ),
      _TestFixDirSlash(
        fullPath: 'file.jpg',
        isDir: true,
        processedPath: 'file.jpg/',
      ),
      _TestFixDirSlash(
        fullPath: '/file.jpg',
        isDir: false,
        processedPath: '/file.jpg',
      ),
      _TestFixDirSlash(
        fullPath: '/file.jpg',
        isDir: true,
        processedPath: '/file.jpg/',
      ),
      _TestFixDirSlash(
        fullPath: '/file/path/to',
        isDir: true,
        processedPath: '/file/path/to/',
      ),
      _TestFixDirSlash(
        fullPath: '/file/path/to/',
        isDir: true,
        processedPath: '/file/path/to/',
      ),
      _TestFixDirSlash(
        fullPath: '/file/path/to/   ',
        isDir: true,
        processedPath: '/file/path/to/   /',
      ),
      _TestFixDirSlash(
        fullPath: '.',
        isDir: true,
        processedPath: './',
      ),
      _TestFixDirSlash(
        fullPath: '/',
        isDir: true,
        processedPath: '/',
      ),
      _TestFixDirSlash(
        fullPath: '',
        isDir: true,
        processedPath: '',
      ),
      _TestFixDirSlash(
        fullPath: ' ',
        isDir: true,
        processedPath: ' /',
      ),
    ];

    for (final item in _testData) {
      expect(
        fixDirSlash(
          fullPath: item.fullPath,
          isDir: item.isDir,
        ),
        equals(item.processedPath),
        reason:
            'failure: ${item.fullPath.toString()} -> ${item.processedPath.toString()}',
      );
    }
  });

  test('getParentPath', () async {
    const _mediaMap = {
      'file.jpg': '',
      '/file.rar': '/',
      'file.tar.gz': '',
      'path/to000/file.23': 'path/to000',
      '/path/to/file.tar.34': '/path/to',
      'path/toget/file/': 'path/toget',
      './78': '',
      '/./78': '/.',
      '.89': '',
      '.': '',
      '': '',
      '/': '/',
      './': '',
      null: '',
      ' ': '',
      ' . ': '',
    };

    for (final item in _mediaMap.entries) {
      expect(getParentPath(item.key), equals(item.value),
          reason: 'failure: ${item.key}');
    }
  });

  test('truncatedFilename', () async {
    const _mediaMap = {
      '': TruncatedFilename(
        original: '',
        firstChunk: '',
        lastChunk: '',
      ),
      'file.ext': TruncatedFilename(
        original: 'file.ext',
        firstChunk: '',
        lastChunk: 'file.ext',
      ),
      'abc.file.123': TruncatedFilename(
        original: 'abc.file.123',
        firstChunk: 'abc.',
        lastChunk: 'file.123',
      ),
      '.tar': TruncatedFilename(
        original: '.tar',
        firstChunk: '',
        lastChunk: '.tar',
      ),
      'txt': TruncatedFilename(
        original: 'txt',
        firstChunk: '',
        lastChunk: 'txt',
      ),
      'abcdefg': TruncatedFilename(
        original: 'abcdefg',
        firstChunk: 'ab',
        lastChunk: 'cdefg',
      ),
    };

    for (final item in _mediaMap.entries) {
      final _fullString = '${item.value.firstChunk}${item.value.lastChunk}';
      final _truncated = truncatedFilename(text: item.key);

      expect(_truncated.firstChunk, equals(item.value.firstChunk),
          reason: 'failure: firstChunk ${item.key}');
      expect(_truncated.lastChunk, equals(item.value.lastChunk),
          reason: 'failure: lastChunk ${item.key}');
      expect(_fullString, equals(item.key),
          reason: 'failure: lastChunk ${item.key}');
    }
  });
}
