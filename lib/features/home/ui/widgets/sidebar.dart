import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_explorer_sidebar.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/button.dart';

class Sidebar extends StatefulWidget {
  final List<FileExplorerSidebarItem> items;
  final FileExplorerScreenStore fileExplorerScreenStore;

  const Sidebar({
    Key key,
    @required this.items,
    @required this.fileExplorerScreenStore,
  })  : assert(items != null),
        assert(fileExplorerScreenStore != null),
        super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends SfWidget<Sidebar> {
  List<FileExplorerSidebarItem> get _items => widget.items;

  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  void _handleOnTap(String fullPath) {
    _fileExplorerScreenStore.navigateToSource(
      fullPath: fullPath,
      source: FileExplorerSource.LOCAL,
      clearStack: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      color: AppColors.colorF5F.withOpacity(0.9),
      child: Column(
        children: List.generate(_items.length, (index) {
          final item = _items[index];

          return Button(
            text: item.label,
            onPressed: () {
              _handleOnTap(item.path);
            },
            buttonType: ButtonType.FLAT,
            icon: item.icon,
            roundedEdge: false,
          );
        }),
      ),
    );
  }
}
