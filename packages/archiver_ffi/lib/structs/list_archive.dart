import 'dart:ffi';

import 'package:archiver_ffi/structs/common.dart';
import 'package:ffi/ffi.dart';

class ArchiveFileInfoStruct extends Struct {
  @Uint32()
  int mode;

  @Uint64()
  int size;

  @Int8()
  int isDir;

  Pointer<Utf8> modTime;

  Pointer<Utf8> name;

  Pointer<Utf8> fullPath;

  Pointer<Utf8> parentPath;

  factory ArchiveFileInfoStruct.allocate(
    int mode,
    int size,
    int isDir,
    Pointer<Utf8> modTime,
    Pointer<Utf8> name,
    Pointer<Utf8> fullPath,
    Pointer<Utf8> parentPath,
  ) =>
      allocate<ArchiveFileInfoStruct>().ref
        ..mode = mode
        ..size = size
        ..isDir = isDir
        ..modTime = modTime
        ..name = name
        ..fullPath = fullPath
        ..parentPath = parentPath;
}

class ArchiveFileInfoResultStruct extends Struct {
  Pointer<Pointer<ArchiveFileInfoStruct>> files;

  @Uint64()
  int totalFiles;

  Pointer<ResultErrorStruct> error;

  factory ArchiveFileInfoResultStruct.allocate(
    Pointer<Pointer<ArchiveFileInfoStruct>> files,
    int totalFiles,
    Pointer<ResultErrorStruct> error,
  ) =>
      allocate<ArchiveFileInfoResultStruct>().ref
        ..files = files
        ..totalFiles = totalFiles
        ..error = error;
}
