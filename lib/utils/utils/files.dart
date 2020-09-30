import 'dart:io';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:path/path.dart' as path;

String getFileName(String pathName) {
  if (isNullOrEmpty(pathName)) {
    return '';
  }

  final file = File(pathName);

  return path.basename(file.path) ?? '';
}

String getFileExtension(String pathName) {
  final _baseName = getFileName(pathName);
  final _ext = _baseName.split('.');

  return _ext?.last ?? '';
}

String homeDirectory() {
  return Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
}

String desktopDirectory() {
  return path.join(homeDirectory(), 'Desktop');
}

String getDesktopFile(String filename) {
  return path.join(desktopDirectory(), filename);
}

String fixDirSlash({
  @required bool isDir,
  @required String fullPath,
}) {
  var _fullPath = fullPath;

  if (isDir &&
      !fullPath.contains(Platform.pathSeparator, fullPath.length - 1)) {
    _fullPath = '$_fullPath${Platform.pathSeparator}';
  }

  return _fullPath;
}
