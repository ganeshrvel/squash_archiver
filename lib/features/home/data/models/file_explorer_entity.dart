import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class FileExplorerSidebarEntity extends Equatable {
  // display label for the tile
  final String label;

  // leading icon
  final IconData icon;

  // file path associated with the tile
  final String path;

  // whether the tile is selected or not
  final bool selected;

  const FileExplorerSidebarEntity({
    required this.label,
    required this.path,
    required this.icon,
    required this.selected,
  });

  FileExplorerSidebarEntity copyWith({
    String? label,
    IconData? icon,
    String? path,
    bool? selected,
  }) {
    return FileExplorerSidebarEntity(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      path: path ?? this.path,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
        selected,
        path,
        icon,
        label,
      ];
}
