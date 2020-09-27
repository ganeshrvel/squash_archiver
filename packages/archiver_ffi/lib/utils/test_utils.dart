import 'dart:io';
import 'package:path/path.dart' as path;

String getTestMocksAsset(String filename) {
  return path.join(Directory.current.path, 'test_assets/' 'mocks/', filename);
}

String getTestMocksBuildAsset(String filename, {bool delete, bool isDir}) {
  final _delete = delete ?? true;
  final _isDir = isDir ?? false;

  final _output = path.join(
    Directory.current.path,
    'test_assets/' 'mocks_build/',
    filename,
  );

  if (_delete) {
    if (_isDir) {
      if (Directory(_output).existsSync()) {
        Directory(_output).deleteSync(recursive: true);
      }
    } else {
      if (File(_output).existsSync()) {
        File(_output).deleteSync(recursive: true);
      }
    }
  }

  return _output;
}

/// check if the string is a date
bool isDate(String str) {
  try {
    DateTime.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}
