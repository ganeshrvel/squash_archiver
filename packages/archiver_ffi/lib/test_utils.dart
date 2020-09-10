import 'dart:io';
import 'package:path/path.dart' as path;

String getTestMocksAsset(String filename) {
  return path.join(Directory.current.path, 'test_assets/' 'mocks/', filename);
}
