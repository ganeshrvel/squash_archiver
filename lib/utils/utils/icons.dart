import 'dart:io';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:path/path.dart' as path;
import 'package:squash_archiver/constants/image_paths.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

const fileIconsMap = {
  '': 'unknown',
  'audio': 'audio',
  'video': 'video',
  'text': 'text',
  'archive': 'archive',
  'jpg': 'jpg',
  'jpe': 'jpg',
  'jpeg': 'jpg',
  'jfif': 'jpg',
  'png': 'png',
  'gif': 'gif',
  'tiff': 'tiff',
  'svg': 'svg',
  'psd': 'psd',
  'ai': 'ai',
  'dwg': 'dwg',
  'iso': 'iso',
  'mdf': 'mdf',
  'nrg': 'nrg',
  'arj': 'arj',
  'rar': 'rar',
  'tar': 'archive',
  'tar.br': 'archive',
  'tar.bz2': 'archive',
  'tar.gz': 'archive',
  'tar.lz4': 'archive',
  'tar.sz': 'archive',
  'tar.xz': 'archive',
  'tar.zst': 'archive',
  'zip': 'zip',
  '7z': '7z',
  '7zip': '7z',
  'xz': 'archive',
  'sz': 'archive',
  'lz4': 'archive',
  'bz2': 'archive',
  'br': 'archive',
  'gz': 'archive',
  'gzip': 'archive',
  'bzip2': 'archive',
  'xls': 'xls',
  'doc': 'doc',
  'pdf': 'pdf',
  'ppt': 'ppt',
  'rtf': 'rtf',
  'txt': 'txt',
  'md': 'text',
  'markdown': 'text',
  'avi': 'avi',
  'mp2': 'mp2',
  'mp3': 'mp3',
  'mp4': 'mp4',
  'fla': 'fla',
  'mxf': 'mxf',
  'wav': 'wav',
  'wma': 'wma',
  'aac': 'aac',
  'flac': 'flac',
  'css': 'css',
  'csv': 'csv',
  'html': 'html',
  'json': 'json',
  'js': 'js',
  'xml': 'xml',
  'dbf': 'dbf',
  'exe': 'exe'
};

/// return the icon file for input file's extension
File getFileIcon(FileInfo file) {
  /// file extension
  final ext = file.extension;

  var _iconFile = fileIconsMap[ext];

  /// if icon file is not available then return 'unknown' icon
  if (isNull(_iconFile)) {
    _iconFile = 'unknown';
  }

  return File(path.join(ImagePaths.FILE_ICONS_DIR, '${_iconFile}.svg'));
}
