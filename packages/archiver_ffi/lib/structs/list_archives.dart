import 'dart:ffi';

import 'package:archiver_ffi/structs/common.dart';
import 'package:ffi/ffi.dart';

enum OrderBy {
  size,
  modTime,
  name,
  fullPath,
}

enum OrderDir {
  asc,
  desc,
  none,
}

class ArcFileInfo extends Struct {
  @Uint32()
  int mode;

  @Int64()
  int size;

  @Int8()
  int isDir;

  Pointer<Utf8> modTime;

  Pointer<Utf8> name;

  Pointer<Utf8> fullPath;

  factory ArcFileInfo.allocate(
    int mode,
    int size,
    int isDir,
    Pointer<Utf8> modTime,
    Pointer<Utf8> name,
    Pointer<Utf8> fullPath,
  ) =>
      allocate<ArcFileInfo>().ref
        ..mode = mode
        ..size = size
        ..isDir = isDir
        ..modTime = modTime
        ..name = name
        ..fullPath = fullPath;
}

class ArcFileInfoResult extends Struct {
  Pointer<Pointer<ArcFileInfo>> files;

  @Int64()
  int totalFiles;

  Pointer<ResultErrors> error;

  factory ArcFileInfoResult.allocate(
    Pointer<Pointer<ArcFileInfo>> files,
    int totalFiles,
    Pointer<ResultErrors> error,
  ) =>
      allocate<ArcFileInfoResult>().ref
        ..files = files
        ..totalFiles = totalFiles
        ..error = error;
}
