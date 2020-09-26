import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class FileInfo extends Equatable {
  final int mode;

  final int size;

  final bool isDir;

  final String modTime;

  final String name;

  final String fullPath;

  const FileInfo({
    @required this.mode,
    @required this.size,
    @required this.isDir,
    @required this.modTime,
    @required this.name,
    @required this.fullPath,
  });

  @override
  List<Object> get props => [
        mode,
        size,
        isDir,
        modTime,
        name,
        fullPath,
      ];
}

class ListArchiveResponse extends Equatable {
  final List<FileInfo> files;

  final int totalFiles;

  const ListArchiveResponse({
    @required this.files,
    @required this.totalFiles,
  });

  @override
  List<Object> get props => [
        files,
        totalFiles,
      ];
}
