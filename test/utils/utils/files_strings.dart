import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/common/models/truncated_string.dart';
import 'package:squash_archiver/utils/utils/strings.dart';

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
  test('truncatedFilename', () async {
    const _mediaMap = {
      '': TruncatedString(
        original: '',
        firstChunk: '',
        lastChunk: '',
      ),
      'file.ext': TruncatedString(
        original: 'file.ext',
        firstChunk: 'fil',
        lastChunk: 'e.ext',
      ),
      'abc.file.123': TruncatedString(
        original: 'abc.file.123',
        firstChunk: 'abc.fil',
        lastChunk: 'e.123',
      ),
      '.tar': TruncatedString(
        original: '.tar',
        firstChunk: '',
        lastChunk: '.tar',
      ),
      'txt': TruncatedString(
        original: 'txt',
        firstChunk: '',
        lastChunk: 'txt',
      ),
      'abcdefg': TruncatedString(
        original: 'abcdefg',
        firstChunk: 'a',
        lastChunk: 'bcdefg',
      ),
    };

    for (final item in _mediaMap.entries) {
      final _fullString = '${item.value.firstChunk}${item.value.lastChunk}';
      final _truncated = truncatedString(text: item.key);

      expect(_truncated.firstChunk, equals(item.value.firstChunk),
          reason: 'failure: firstChunk ${item.key}');
      expect(_truncated.lastChunk, equals(item.value.lastChunk),
          reason: 'failure: lastChunk ${item.key}');
      expect(_fullString, equals(item.key),
          reason: 'failure: lastChunk ${item.key}');
    }
  });
}
