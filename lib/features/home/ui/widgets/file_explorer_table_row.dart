import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/colors.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/constants/image_paths.dart';
import 'package:squash_archiver/constants/sizes.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/utils/utils/icons.dart';
import 'package:squash_archiver/widgets/app_tooltip/app_tooltip.dart';
import 'package:squash_archiver/widgets/img/img.dart';
import 'package:squash_archiver/widgets/text/textography.dart';
import 'package:squash_archiver/widgets/text/truncated_text.dart';

class FileExplorerTableRowTile extends StatelessWidget {
  final int rowIndex;

  final FileListingResponse fileContainer;

  final bool isSelected;

  const FileExplorerTableRowTile({
    Key key,
    @required this.fileContainer,
    @required this.rowIndex,
    @required this.isSelected,
  })  : assert(rowIndex != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _palette = getPalette(context);

    const _textFontVariant = TextVariant.body2;
    const _textFontWeight = FontWeight.w700;
    var _metaDataTextColor = _palette.textColor.withOpacity(0.6);
    var _textColor = _palette.textColor;

    File _fileIcon;
    const _fileIconHeight = 24.0;

    var _rowColor = rowIndex % 2 == 0
        ? _palette.backgroundColor
        : _palette.alternativeRowColor;
    if (isSelected) {
      _rowColor = _palette.rowSelectionColor;
      _textColor = _palette.rowTextContrastColor;
      _metaDataTextColor = _palette.rowTextContrastColor.withOpacity(0.7);
    }

    if (!fileContainer.file.isDir) {
      _fileIcon = getFileIcon(fileContainer.file);
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
                  const Img(
                    ImagePaths.FOLDER_ICON,
                    height: _fileIconHeight,
                  )
                else
                  Img(
                    _fileIcon.path,
                    isSvg: true,
                    height: _fileIconHeight,
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
                      color: _textColor,
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
  }
}
