import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ArchiveFileInfo extends Equatable {
  final int mode;

  final int size;

  final bool isDir;

  final String modTime;

  final String name;

  final String fullPath;

  final String parentPath;

  const ArchiveFileInfo({
    @required this.mode,
    @required this.size,
    @required this.isDir,
    @required this.modTime,
    @required this.name,
    @required this.fullPath,
    @required this.parentPath,
  });

  @override
  List<Object> get props => [
        mode,
        size,
        isDir,
        modTime,
        name,
        fullPath,
        parentPath,
      ];
}
