import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class FileExplorerSidebarItem {
  final String label;
  final IconData icon;
  final String path;

  FileExplorerSidebarItem({
    @required this.label,
    @required this.path,
    @required this.icon,
  });
}
