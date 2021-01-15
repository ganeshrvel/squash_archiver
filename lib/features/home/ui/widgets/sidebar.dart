import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_explorer_entity.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class Sidebar extends StatefulWidget {
  final List<FileExplorerSidebarEntity> entities;
  final FileExplorerScreenStore fileExplorerScreenStore;

  const Sidebar({
    Key key,
    @required this.entities,
    @required this.fileExplorerScreenStore,
  })  : assert(entities != null),
        assert(fileExplorerScreenStore != null),
        super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends SfWidget<Sidebar> {
  List<FileExplorerSidebarEntity> get _items => widget.entities;

  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  void _handleOnTap(String fullPath) {
    _fileExplorerScreenStore.navigateToSource(
      fullPath: fullPath,
      source: FileExplorerSource.LOCAL,
      clearStack: true,
    );
  }

  Widget _buildFavorites() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Textography(
            'Favorites',
            fontSize: 12,
            color: AppColors.color797,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Column(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final _iconColor =
                  item.selected ? AppColors.white : AppColors.blue;
              final _tileColor = item.selected ? AppColors.blue : null;
              final _tileTextColor =
                  item.selected ? AppColors.white : AppColors.black.withOpacity(0.8);

              return InkWell(
                onTap: () {
                  _handleOnTap(item.path);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _tileColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 16,
                        color: _iconColor,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Textography(
                        item.label,
                        variant: TextVariant.body2,
                        fontWeight: FontWeight.w600,
                        color: _tileTextColor,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 11,
      ),
      color: AppColors.colorE6E3E3.withOpacity(0.97),
      child: Column(
        children: [
          _buildFavorites(),
        ],
      ),
    );
  }
}
