import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart' show ReactionDisposer;
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/constants/sizes.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/app_tooltip/app_tooltip.dart';
import 'package:squash_archiver/widgets/inkwell_extended/inkwell_extended.dart';
import 'package:squash_archiver/widgets/text/textography.dart';
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

  List<ReactionDisposer> _disposers = [];

  @override
  void dispose() {
    _disposers ??= [];

    super.dispose();
  }

  Future<void> _navigateToNextPath(FileListingResponse fileContainer) async {
    if (fileContainer.file.isDir) {
      return _fileExplorerScreenStore
          .setCurrentPath(fileContainer.file.fullPath);
    }

    /// if the file extension is supported by the archiver then open the archive
    if (fileContainer.isSupported) {
      return _fileExplorerScreenStore.navigateToSource(
        fullPath: '',
        currentArchiveFilepath: fileContainer.file.fullPath,
        source: FileExplorerSource.ARCHIVE,
        clearStack: false,
      );
    }
  }

  Widget _buildRow({
    @required FileListingResponse fileContainer,
    @required int index,
  }) {
    assert(fileContainer != null);
    assert(index != null);

    return Listener(
      onPointerDown: (PointerDownEvent event) {
        /// mouse right click
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
        cursor: SystemMouseCursors.basic,

        /// [InkWellSplash] package is used here because [onDoubleTap] was delaying the [onTap] performance
        /// github issue: https://github.com/flutter/flutter/issues/22950
        child: InkWellExtended(
          onDoubleTap: () {
            _navigateToNextPath(fileContainer);
          },
          onTap: () {
            _fileExplorerScreenStore.setSelectedFiles(fileContainer);
          },
          child: Observer(builder: (_) {
            final _selectedFiles = _fileExplorerScreenStore.selectedFiles;
            final _isSelected = _selectedFiles.contains(fileContainer);

            const _textFontVariant = TextVariant.body2;
            const _textFontWeight = FontWeight.w700;
            final _metaDataTextColor = AppColors.color797;

            var _rowColor =
                index % 2 == 0 ? AppColors.white : AppColors.colorF5F;
            if (_isSelected) {
              _rowColor = AppColors.darkBlue;
            }

            return Container(
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
                        if (fileContainer.file.isDir)
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
                            message: fileContainer.file.name,
                            child: TruncatedText(
                              truncatedText: fileContainer.truncatedFilename,
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.FILE_EXPLORER_ROW_HORZ_PADDING,
                      ),
                      child: AppTooltip(
                        message: fileContainer.prettyFileSize,
                        child: Textography(
                          fileContainer.prettyFileSize,
                          variant: _textFontVariant,
                          fontWeight: _textFontWeight,
                          color: _metaDataTextColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        /// correcting the padding for date column
                        horizontal: Sizes.FILE_EXPLORER_ROW_HORZ_PADDING * 2,
                      ),
                      child: AppTooltip(
                        message: fileContainer.prettyDate,
                        child: Textography(
                          fileContainer.prettyDate,
                          variant: _textFontVariant,
                          fontWeight: _textFontWeight,
                          color: _metaDataTextColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final _files = _fileExplorerScreenStore.files;
      final _rowsLength = _files.length;

      return SliverList(
        delegate: SliverChildBuilderDelegate((
          BuildContext context,
          int index,
        ) {
          if (index >= _rowsLength) {
            return null;
          }

          final _fileContainer = _files[index];

          return _buildRow(
            fileContainer: _fileContainer,
            index: index,
          );
        }),
      );
    });
  }
}
