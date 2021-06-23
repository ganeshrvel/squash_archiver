import 'dart:ffi';

import 'package:archiver_ffi/src/structs/common.dart';
import 'package:ffi/ffi.dart';

class ArchiveFileInfoStruct extends Struct {
  @Uint32()
  external int mode;

  @Uint64()
  external int size;

  @Int8()
  external int isDir;

  external Pointer<Utf8> modTime;

  external Pointer<Utf8> name;

  external Pointer<Utf8> fullPath;

  external Pointer<Utf8> parentPath;

  external Pointer<Utf8> extension;

  factory ArchiveFileInfoStruct.allocate(
    int mode,
    int size,
    int isDir,
    Pointer<Utf8> modTime,
    Pointer<Utf8> name,
    Pointer<Utf8> fullPath,
    Pointer<Utf8> parentPath,
    Pointer<Utf8> extension,
  ) =>
      malloc<ArchiveFileInfoStruct>().ref
        ..mode = mode
        ..size = size
        ..isDir = isDir
        ..modTime = modTime
        ..name = name
        ..fullPath = fullPath
        ..parentPath = parentPath
        ..extension = extension;
}

class ArchiveFileInfoResultStruct extends Struct {
  external Pointer<Pointer<ArchiveFileInfoStruct>> files;

  @Uint64()
  external int totalFiles;

  external Pointer<ResultErrorStruct> error;

  factory ArchiveFileInfoResultStruct.allocate(
    Pointer<Pointer<ArchiveFileInfoStruct>> files,
    int totalFiles,
    Pointer<ResultErrorStruct> error,
  ) =>
      malloc<ArchiveFileInfoResultStruct>().ref
        ..files = files
        ..totalFiles = totalFiles
        ..error = error;
}
