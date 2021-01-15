import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class FileExplorerSidebarEntity {
  final String label;
  final IconData icon;
  final String path;
  final bool selected;

  FileExplorerSidebarEntity({
    @required this.label,
    @required this.path,
    @required this.icon,
    @required this.selected,
  });
}
