import 'dart:io';
import 'package:archiver_ffi/constants/app_files.dart';
import 'package:path/path.dart' as path;

String getNativeLibRoot() {
  return path.join(Directory.current.path, 'native/', 'archiver_lib/');
}

String getNativeLib({bool fullPath}) {
  final _fullPath = fullPath ?? false;

  if (_fullPath) {
    return path.join(getNativeLibRoot(), 'build/', AppFiles.ARCHIVER_FFI_LIB);
  }

  return AppFiles.ARCHIVER_FFI_LIB;
}

String enumToString<T>(T value) {
  if (value == null) {
    return null;
  }

  return value.toString().split('.').last;
}
