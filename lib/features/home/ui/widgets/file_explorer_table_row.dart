import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/constants/sizes.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/widgets/app_tooltip/app_tooltip.dart';
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
    const _textFontVariant = TextVariant.body2;
    const _textFontWeight = FontWeight.w700;
    final _metaDataTextColor = AppColors.color797;

    var _rowColor = rowIndex % 2 == 0 ? AppColors.white : AppColors.colorF5F;
    if (isSelected) {
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
  }
}
