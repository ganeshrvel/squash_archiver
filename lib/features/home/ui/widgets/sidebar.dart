import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/constants/sizes.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_explorer_entity.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/app_list_tile/app_list_tile.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class Sidebar extends StatefulWidget {
  final FileExplorerScreenStore fileExplorerScreenStore;

  const Sidebar({
    Key key,
    @required this.fileExplorerScreenStore,
  })  : assert(fileExplorerScreenStore != null),
        super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends SfWidget<Sidebar> {
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
    final _entities = [
      FileExplorerSidebarEntity(
        label: 'Home',
        path: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
        icon: CupertinoIcons.home,
        selected: true,
      ),
      FileExplorerSidebarEntity(
        label: 'Desktop',
        path: desktopDirectory(),
        icon: CupertinoIcons.desktopcomputer,
        selected: false,
      ),
      FileExplorerSidebarEntity(
        label: 'Download',
        path: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
        icon: CupertinoIcons.arrow_down_circle,
        selected: false,
      ),
    ];

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
            children: List.generate(_entities.length, (index) {
              final entity = _entities[index];

              return AppListTile(
                onTap: () {
                  _handleOnTap(entity.path);
                },
                selected: entity.selected,
                icon: entity.icon,
                label: entity.label,
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
      child: Container(
        margin: const EdgeInsets.only(top: Sizes.TITLE_BAR_PADDING),
        child: Column(
          children: [
            _buildFavorites(),
          ],
        ),
      ),
    );
  }
}
