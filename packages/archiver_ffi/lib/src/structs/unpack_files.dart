import 'dart:ffi';

import 'package:archiver_ffi/src/structs/common.dart';
import 'package:ffi/ffi.dart';

final class UnpackFilesStruct extends Struct {
  external Pointer<Utf8> startTime;

  external Pointer<Utf8> currentFilename;

  @Uint32()
  external int totalFiles;

  @Uint64()
  external int progressCount;

  @Double()
  external double progressPercentage;

  @Int8()
  external int ended;

  external Pointer<ResultErrorStruct> error;

  factory UnpackFilesStruct.allocate(
    Pointer<Utf8> startTime,
    Pointer<Utf8> currentFilename,
    int totalFiles,
    int progressCount,
    double progressPercentage,
    int ended,
    Pointer<ResultErrorStruct> error,
  ) =>
      malloc<UnpackFilesStruct>().ref
        ..startTime = startTime
        ..currentFilename = currentFilename
        ..totalFiles = totalFiles
        ..progressCount = progressCount
        ..progressPercentage = progressPercentage
        ..ended = ended
        ..error = error;
}
