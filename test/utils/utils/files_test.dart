import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
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
      'file.jpg': 'jpg',
      'file.rar': 'rar',
      'file.tar.gz': 'tar.gz',
      'file.12': '12',
      'path/to/file.23': '23',
      'path/to/file.tar.34': 'tar.34',
      'path/to.get/file.tar.56': 'tar.56',
      'path/to/file./78': '',
      'path/to/file./.89': '89',
      'qwerty': '',
      '.htaccess': 'htaccess',
      '..htaccess': '.htaccess',
      '.': '',
      '': '',
      null: '',
      ' ': '',
      ' . ': ' ',
    };

    for (final item in _mediaMap.entries) {
      expect(getExtension(item.key), equals(item.value));
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
      expect(getParentPath(item.key), equals(item.value));
    }
  });
}
