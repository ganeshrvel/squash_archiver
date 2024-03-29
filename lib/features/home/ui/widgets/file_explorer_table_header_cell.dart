import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/common/models/theme_palette.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/constants/sizes.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/inkwell_extended/inkwell_extended.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerTableHeaderCell extends StatelessWidget {
  /// title of the cell
  final String title;

  /// the [OrderBy] type of the cell
  final OrderBy orderBy;

  /// the selected [OrderDir] state
  final OrderDir selectedOrderDir;

  /// the selected [OrderBy] state
  final OrderBy selectedOrderBy;

  /// disable actions if the loading is true
  final bool isLoading;

  /// show the seperator in the table header cell
  final bool showSeparator;

  /// on tap action return the next [OrderDir] and [OrderBy] to sort to
  final Function({
    @required OrderDir orderDir,
    @required OrderBy orderBy,
  }) onTap;

  const FileExplorerTableHeaderCell({
    Key key,
    @required this.title,
    @required this.orderBy,
    @required this.onTap,
    @required this.isLoading,
    @required this.selectedOrderDir,
    @required this.selectedOrderBy,
    this.showSeparator = true,
  })  : assert(title != null),
        assert(orderBy != null),
        assert(onTap != null),
        assert(isLoading != null),
        assert(selectedOrderDir != null),
        assert(selectedOrderBy != null),
        assert(showSeparator != null),
        super(key: key);

  bool get _isLoading => isLoading ?? false;

  Color _textColor(BuildContext context) {
    final _p = _palette(context);

    return orderBy == selectedOrderBy
        ? _p.textColor
        : _p.textColor.withOpacity(0.60);
  }

  ThemePalette _palette(BuildContext context) => getPalette(context);

  void _handleOnTap() {
    if (isNull(onTap)) {
      return;
    }

    OrderDir _nextOrderDir;

    switch (selectedOrderDir) {
      case OrderDir.asc:

        /// the next [orderDir]
        _nextOrderDir = OrderDir.desc;

        /// if the [orderBy] is different than the [selectedOrderBy]
        /// then the [selectedOrderBy] = [orderDir]
        if (selectedOrderBy != orderBy) {
          _nextOrderDir = OrderDir.asc;
        }

        break;
      case OrderDir.desc:
      default:
        _nextOrderDir = OrderDir.asc;
        if (selectedOrderBy != orderBy) {
          _nextOrderDir = OrderDir.desc;
        }

        break;
    }

    onTap(
      orderBy: orderBy,
      orderDir: _nextOrderDir,
    );
  }

  Widget _buildOrderDirIcon(BuildContext context) {
    /// don't display the [orderDir] icon if [orderBy] is not equal to [selectedOrderBy]
    if (orderBy != selectedOrderBy) {
      return Container();
    }

    Widget _icon = Container();
    const _size = 10.0;

    switch (selectedOrderDir) {
      case OrderDir.asc:
        _icon = Icon(
          CupertinoIcons.control,
          color: _textColor(context),
          size: _size,
        );

        break;
      case OrderDir.desc:
        _icon = Icon(
          CupertinoIcons.chevron_down,
          color: _textColor(context),
          size: _size,
        );

        break;
      case OrderDir.none:
      default:
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWellExtended(
        onTap: _handleOnTap,
        child: Stack(
          children: [
            Container(
              height: 28,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: _palette(context).sidebarColor,
                    width: 0.9,
                  ),
                ),
                color: _palette(context).backgroundColor,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.FILE_EXPLORER_ROW_HORZ_PADDING +
                      Sizes.FILE_EXPLORER_HORZ_PADDING,
                ),
                child: Textography(
                  title,
                  color: _textColor(context),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildOrderDirIcon(context),
            ),
            if (showSeparator)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  color: _palette(context).sidebarColor,
                  width: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
