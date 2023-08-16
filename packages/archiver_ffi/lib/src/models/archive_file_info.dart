import 'package:equatable/equatable.dart';

class FileInfo extends Equatable {
  final int mode;

  final int size;

  final bool isDir;

  final String modTime;

  final String name;

  final String kind;

  final String fullPath;

  final String parentPath;

  final String extension;

  const FileInfo({
    required this.mode,
    required this.size,
    required this.isDir,
    required this.modTime,
    required this.name,
    required this.kind,
    required this.fullPath,
    required this.parentPath,
    required this.extension,
  });

  FileInfo copyWith({
    int? mode,
    int? size,
    bool? isDir,
    String? modTime,
    String? name,
    String? kind,
    String? fullPath,
    String? parentPath,
    String? extension,
  }) {
    return FileInfo(
      fullPath: fullPath ?? this.fullPath,
      size: size ?? this.size,
      modTime: modTime ?? this.modTime,
      mode: mode ?? this.mode,
      isDir: isDir ?? this.isDir,
      name: name ?? this.name,
      kind: kind ?? this.kind,
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
        kind,
        fullPath,
        parentPath,
        extension,
      ];

  @override
  String toString() {
    super.toString();

    return '''
        mode: $mode,
        size: $size,
        isDir: $isDir,
        modTime: $modTime,
        name: $name,
        kind: $kind,
        fullPath: $fullPath,
        parentPath: $parentPath,
        extension: $extension,
        ''';
  }
}
