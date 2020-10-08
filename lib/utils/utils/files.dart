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

String rootDirectory() {
  return '/';
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

  if (isNullOrEmpty(fullPath)) {
    return '';
  }

  if (fullPath == Platform.pathSeparator) {
    return _fullPath;
  }

  final _offset = fullPath.length - 1;

  if (isDir && !fullPath.contains(Platform.pathSeparator, _offset)) {
    _fullPath = '$_fullPath${Platform.pathSeparator}';
  }

  return _fullPath;
}

///todo write test cases
String getParentPath(String fullPath) {
  if (isNullOrEmpty(fullPath)) {
    return '';
  }

  if (fullPath == Platform.pathSeparator) {
    return fullPath;
  }

  final _parentDir = Directory(fullPath).parent.path;

  if (_parentDir == '.') {
    return '';
  }

  return _parentDir;
}

List<FileSystemEntity> listDirectory(Directory dir, {bool recursive}) {
  final _recursive = recursive ?? false;

  final _files = <FileSystemEntity>[];

  final _contents = dir.listSync(
    recursive: _recursive,
    followLinks: false,
  );

  for (final file in _contents) {
    if (file is File) {
      _files.add(file);
    } else if (file is Directory) {
      _files.add(file);
    }
  }

  return _files;
}
