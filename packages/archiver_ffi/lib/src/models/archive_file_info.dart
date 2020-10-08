import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class FileInfo extends Equatable {
  final int mode;

  final int size;

  final bool isDir;

  final String modTime;

  final String name;

  final String fullPath;

  final String parentPath;

  final String extension;

  const FileInfo({
    @required this.mode,
    @required this.size,
    @required this.isDir,
    @required this.modTime,
    @required this.name,
    @required this.fullPath,
    @required this.parentPath,
    @required this.extension,
  });

  FileInfo copyWith({
    int mode,
    int size,
    bool isDir,
    String modTime,
    String name,
    String fullPath,
    String parentPath,
    String extension,
  }) {
    return FileInfo(
      fullPath: fullPath ?? this.fullPath,
      size: size ?? this.size,
      modTime: modTime ?? this.modTime,
      mode: mode ?? this.mode,
      isDir: isDir ?? this.isDir,
      name: name ?? this.name,
      parentPath: parentPath ?? this.parentPath,
      extension: extension ?? this.extension,
    );
  }

  @override
  List<Object> get props => [
        mode,
        size,
        isDir,
        modTime,
        name,
        fullPath,
        parentPath,
        extension,
      ];
}
