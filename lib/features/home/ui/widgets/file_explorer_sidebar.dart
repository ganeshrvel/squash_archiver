import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/helpers/files_helper.dart';
import 'package:squash_archiver/helpers/provider_helpers.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

typedef SidebarEntity = ({
  Widget icon,
  String label,
  String path,
});

class FileExplorerSidebar extends StatefulWidget {
  final ScrollController sidebarScrollController;

  const FileExplorerSidebar({
    required this.sidebarScrollController,
    super.key,
  });

  @override
  _FileExplorerSidebarState createState() => _FileExplorerSidebarState();
}

class _FileExplorerSidebarState extends SfWidget<FileExplorerSidebar> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  ScrollController get _sidebarScrollController =>
      widget.sidebarScrollController;

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

  List<SidebarEntity> get _sidebarEntities {
    return [
      if (isNotNullOrEmpty(AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY))
        (
          label: 'Home',
          path: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY!,
          icon: const MacosIcon(CupertinoIcons.home),
        ),
      (
        label: 'Desktop',
        path: desktopDirectory(),
        icon: const MacosIcon(CupertinoIcons.desktopcomputer),
      ),
      (
        label: 'Downloads',
        path: downloadsDirectory(),
        icon: const MacosIcon(CupertinoIcons.arrow_down_circle),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final _currentPath = _fileExplorerScreenStore.currentPath;
        var _hasMenubarSelection = false;
        var _currentSelectedIndex = 0;

        for (var i = 0; i < _sidebarEntities.length; i += 1) {
          final _entity = _sidebarEntities[i];
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
            _currentSelectedIndex = i;
            _hasMenubarSelection = true;

            break;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 15,
                ),
                child: Textography(
                  'Favorites',
                  typographyVariant: TypographyVariant.Secondary,
                  textAlign: TextAlign.left,
                  variant: TextVariant.Subheadline,
                  fontWeight: MacosFontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SidebarItems(
                  currentIndex: _currentSelectedIndex,
                  hasActiveSelection: _hasMenubarSelection,
                  onChanged: (i) {
                    _handleOnTap(_sidebarEntities[i].path);
                  },
                  scrollController: _sidebarScrollController,
                  itemSize: SidebarItemSize.medium,
                  items: [
                    for (final item in _sidebarEntities)
                      SidebarItem(
                        leading: item.icon,
                        label: Textography(
                          item.label,
                          preventAutoTextStyling: true,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
