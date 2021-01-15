import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerTableHeaderCell extends StatelessWidget {
  /// title of the cell
  final String title;

  /// the [OrderBy] type of the cell
  final OrderBy orderBy;

  /// on tap action return the next [OrderDir] and [OrderBy] to sort to
  final Function({
    @required OrderDir orderDir,
    @required OrderBy orderBy,
  }) onTap;

  /// disable actions if the loading is true
  final bool isLoading;

  /// the current [OrderDir] state
  final OrderDir currentOrderDir;

  const FileExplorerTableHeaderCell({
    Key key,
    @required this.title,
    @required this.orderBy,
    @required this.onTap,
    @required this.isLoading,
    @required this.currentOrderDir,
  }) : super(key: key);

  bool get _isLoading => isLoading ?? false;

  void _handleOnTap() {
    if (isNull(onTap)) {
      return;
    }

    OrderDir _nextOrderDir;

    switch (currentOrderDir) {
      case OrderDir.asc:
        _nextOrderDir = OrderDir.desc;

        break;
      case OrderDir.desc:
        _nextOrderDir = OrderDir.none;

        break;
      case OrderDir.none:
        _nextOrderDir = OrderDir.asc;

        break;
    }

    onTap(
      orderBy: orderBy,
      orderDir: _nextOrderDir,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: _handleOnTap,
        child: Container(
          color: AppColors.colorF1F,
          child: Textography(title),
        ),
      ),
    );
  }
}
