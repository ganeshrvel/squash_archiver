import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/common/helpers/provider_helpers.dart';
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

class FileExplorerSidebar extends StatefulWidget {
  const FileExplorerSidebar({
    Key key,
  }) : super(key: key);

  @override
  _FileExplorerSidebarState createState() => _FileExplorerSidebarState();
}

class _FileExplorerSidebarState extends SfWidget<FileExplorerSidebar> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  @override
  void initState() {
    super.initState();
  }

  void _handleOnTap(String fullPath) {
    _fileExplorerScreenStore.navigateToSource(
      fullPath: fullPath,
      source: FileExplorerSource.LOCAL,
      clearStack: true,
    );
  }

  Widget _buildFavorites() {
    return Observer(builder: (_) {
      final _currentPath = _fileExplorerScreenStore.currentPath;

      final _entities = [
        FileExplorerSidebarEntity(
          label: 'Home',
          path: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
          icon: CupertinoIcons.home,
          selected: false,
        ),
        FileExplorerSidebarEntity(
          label: 'Desktop',
          path: desktopDirectory(),
          icon: CupertinoIcons.desktopcomputer,
          selected: false,
        ),
        FileExplorerSidebarEntity(
          label: 'Downloads',
          path: downloadsDirectory(),
          icon: CupertinoIcons.arrow_down_circle,
          selected: false,
        ),
      ];

      for (var i = 0; i < _entities.length; i += 1) {
        final _entity = _entities[i];
        // if the current path (as recorded in the store) is same as the path of the entity
        // then mark it as selected
        final _currentPathCleaned = fixDirSlash(
          fullPath: _currentPath,
          isDir: true,
        );

        final _entityPathCleaned = fixDirSlash(
          fullPath: _entity.path,
          isDir: true,
        );

        if (_currentPathCleaned == _entityPathCleaned) {
          _entities[i] = _entity.copyWith(
            selected: _currentPathCleaned == _entityPathCleaned,
          );
        }
      }

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
    });
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
