import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

String getTestMocksAsset(String filename, {bool isDir}) {
  final _isDir = isDir ?? false;

  final _filePath = path.join(
    Directory.current.path,
    'test',
    'test_assets/',
    'mocks/',
    filename,
  );

  if (_isDir) {
    if (!Directory(_filePath).existsSync()) {
      throw "The mock directory '${filename}' does not exists";
    }
  } else {
    if (!File(_filePath).existsSync()) {
      throw "The mock file '${filename}' does not exists";
    }
  }

  return _filePath;
}

String getTestMocksBuildAsset(String filename, {bool delete, bool isDir}) {
  final _delete = delete ?? true;
  final _isDir = isDir ?? false;

  final _output = path.join(
    Directory.current.path,
    'test',
    'test_assets/',
    'mocks_build/',
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

Future<List<FileSystemEntity>> dirContents(Directory dir) async {
  return dir.listSync(recursive: true).toList();
}
