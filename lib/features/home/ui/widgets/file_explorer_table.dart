import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerTable extends StatefulWidget {
  final FileExplorerScreenStore fileExplorerScreenStore;

  const FileExplorerTable({
    Key key,
    @required this.fileExplorerScreenStore,
  })  : assert(fileExplorerScreenStore != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FileExplorerTableState();
}

class _FileExplorerTableState extends SfWidget<FileExplorerTable> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  Future<void> _navigateToNextPath(FileListingResponse fileResponse) async {
    if (fileResponse.file.isDir) {
      return _fileExplorerScreenStore
          .setCurrentPath(fileResponse.file.fullPath);
    }

    /// if the file extension is supported by the archiver then open the archive
    if (fileResponse.isSupported) {
      return _fileExplorerScreenStore.navigateToSource(
        fullPath: '',
        currentArchiveFilepath: fileResponse.file.fullPath,
        source: FileExplorerSource.ARCHIVE,
        clearStack: false,
      );
    }
  }

  List<Widget> _buildRows({
    @required List<FileListingResponse> files,
  }) {
    return files.map((fileResponse) {
      return Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons == 2) {
            showMenu(
              elevation: 2,
              context: context,
              position: RelativeRect.fromLTRB(
                event.position.dx,
                event.position.dy,
                event.position.dx,
                event.position.dy,
              ),
              items: const <PopupMenuItem<String>>[
                PopupMenuItem(value: 'test1', child: Textography('test1')),
                PopupMenuItem(value: 'test2', child: Textography('test2')),
              ],
            );
          }
        },
        child: MouseRegion(
          child: GestureDetector(
            onDoubleTap: () {
              _navigateToNextPath(fileResponse);
            },
            child: ListTile(
              mouseCursor: SystemMouseCursors.basic,
              hoverColor: AppColors.transparent,
              focusColor: AppColors.transparent,
              selectedTileColor: AppColors.blue,
              title: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (fileResponse.file.isDir)
                          Icon(
                            Icons.folder,
                            color: AppColors.blue,
                          )
                        else
                          const Icon(Icons.file_copy_rounded),
                        const SizedBox(width: 5),
                        Textography(
                          fileResponse.file.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Textography(fileResponse.prettyFileSize),
                  ),
                  Expanded(
                    child: Textography(fileResponse.prettyDate),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final _files = _fileExplorerScreenStore.files;

      final _rows = _buildRows(files: _files);
      final _rowsLength = _rows.length;

      return SliverList(
        delegate: SliverChildBuilderDelegate((
          BuildContext context,
          int index,
        ) {
          if (index >= _rowsLength) {
            return null;
          }

          //   final _key = ValueKey(media.id);

          // To convert this infinite list to a list with three items,
          // uncomment the following line:
          // if (index > 3) return null;
          return _rows[index];
        }),
      );
    });
  }
}
