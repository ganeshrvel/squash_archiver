import 'dart:ffi';

import 'package:archiver_ffi/src/structs/common.dart';
import 'package:ffi/ffi.dart';

class UnpackFilesStruct extends Struct {
  Pointer<Utf8> startTime;

  Pointer<Utf8> currentFilename;

  @Uint32()
  int totalFiles;

  @Uint64()
  int progressCount;

  @Double()
  double progressPercentage;

  @Int8()
  int ended;

  Pointer<ResultErrorStruct> error;

  factory UnpackFilesStruct.allocate(
    Pointer<Utf8> startTime,
    Pointer<Utf8> currentFilename,
    int totalFiles,
    int progressCount,
    double progressPercentage,
    int ended,
    Pointer<ResultErrorStruct> error,
  ) =>
      allocate<UnpackFilesStruct>().ref
        ..startTime = startTime
        ..currentFilename = currentFilename
        ..totalFiles = totalFiles
        ..progressCount = progressCount
        ..progressPercentage = progressPercentage
        ..ended = ended
        ..error = error;
}
