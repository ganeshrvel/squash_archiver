import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/constants/sizes.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/app_tooltip/app_tooltip.dart';
import 'package:squash_archiver/widgets/text/textography.dart';
import 'package:dartx/dartx.dart';
import 'package:squash_archiver/widgets/text/truncated_text.dart';

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
    const _textFontVariant = TextVariant.body2;
    const _textFontWeight = FontWeight.w700;

    return files.mapIndexed((index, fileResponse) {
      final _rowColor = index % 2 == 0 ? AppColors.white : AppColors.colorF5F;
      final _metaDataTextColor = AppColors.color797;

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
            child: Container(
              decoration: BoxDecoration(
                color: _rowColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.FILE_EXPLORER_ROW_HORZ_PADDING,
                vertical: 4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (fileResponse.file.isDir)
                          Icon(
                            CupertinoIcons.folder_fill,
                            color: AppColors.blue,
                            size: 20,
                          )
                        else
                          const Icon(
                            CupertinoIcons.doc_fill,
                            size: 20,
                          ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: AppTooltip(
                            message: fileResponse.file.name,
                            child: TruncatedText(
                              fileResponse.file.name,
                              overflow: TextOverflow.ellipsis,
                              variant: _textFontVariant,
                              fontWeight: _textFontWeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Textography(
                      fileResponse.prettyFileSize,
                      variant: _textFontVariant,
                      fontWeight: _textFontWeight,
                      color: _metaDataTextColor,
                    ),
                  ),
                  Expanded(
                    child: Textography(
                      fileResponse.prettyDate,
                      variant: _textFontVariant,
                      fontWeight: _textFontWeight,
                      color: _metaDataTextColor,
                    ),
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

          return _rows[index];
        }),
      );
    });
  }
}
