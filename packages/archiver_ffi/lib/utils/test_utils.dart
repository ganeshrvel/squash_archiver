import 'dart:io';
import 'package:path/path.dart' as path;

String getTestMocksAsset(String filename) {
  return path.join(Directory.current.path, 'test_assets/' 'mocks/', filename);
}

String getTestMocksBuildAsset(String filename) {
  return path.join(
      Directory.current.path, 'test_assets/' 'mocks_build/', filename);
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
