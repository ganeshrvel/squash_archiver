import 'dart:io';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:path/path.dart';

String getFileName(String pathName) {
  if (isNullOrEmpty(pathName)) {
    return '';
  }

  final file = File(pathName);

  return basename(file.path) ?? '';
}

String getFileExtension(String pathName) {
  final _baseName = getFileName(pathName);
  final _ext = _baseName.split('.');

  return _ext?.last ?? '';
}
