import 'dart:ffi';
import 'dart:io';
import 'package:archiver_ffi/constants/app_files.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

String getNativeLibRoot() {
  return path.join(Directory.current.path, 'native/', 'archiver_lib/');
}

String getNativeLib({bool fullpath}) {
  final _fullpath = fullpath ?? false;

  if (_fullpath) {
    return path.join(getNativeLibRoot(), 'build/', AppFiles.ARCHIVER_FFI_LIB);
  }

  return AppFiles.ARCHIVER_FFI_LIB;
}

int ffiBool(bool value) {
  return value ? 1 : 0;
}

Pointer<Int8> ffiString(String value, List<Pointer<Int8>> ptrList) {
  final _value = Utf8.toUtf8(value);
  final _ptr = _value.cast<Int8>();

  ptrList.add(_ptr);

  return _ptr;
}

String enumToString<T>(T value) {
  if (value == null) {
    return null;
  }

  return value.toString().split('.').last;
}
