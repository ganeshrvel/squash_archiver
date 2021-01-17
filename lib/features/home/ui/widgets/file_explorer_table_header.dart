import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table_header_cell.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

class FileExplorerTableHeader extends StatefulWidget {
  final FileExplorerScreenStore fileExplorerScreenStore;

  const FileExplorerTableHeader({
    Key key,
    @required this.fileExplorerScreenStore,
  })  : assert(fileExplorerScreenStore != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => FileExplorerTableHeaderState();
}

class FileExplorerTableHeaderState extends SfWidget<FileExplorerTableHeader> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      widget.fileExplorerScreenStore;

  void _handleTableHeaderCellSorting({
    @required OrderDir orderDir,
    @required OrderBy orderBy,
  }) {
    _fileExplorerScreenStore.setOrderDirOrderBy(
      orderBy: orderBy,
      orderDir: orderDir,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      color: AppColors.white,
      child: Center(
        child: Observer(
          builder: (_) {
            final _orderDir = _fileExplorerScreenStore.orderDir;
            final _orderBy = _fileExplorerScreenStore.orderBy;
            final _listFilesInProgress =
                _fileExplorerScreenStore.fileListingInProgress;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FileExplorerTableHeaderCell(
                  isLoading: _listFilesInProgress,
                  title: 'Name',
                  orderBy: OrderBy.name,
                  selectedOrderDir: _orderDir,
                  selectedOrderBy: _orderBy,
                  onTap: _handleTableHeaderCellSorting,
                  showSeparator: false,
                ),
                FileExplorerTableHeaderCell(
                  isLoading: _listFilesInProgress,
                  title: 'Size',
                  orderBy: OrderBy.size,
                  selectedOrderDir: _orderDir,
                  onTap: _handleTableHeaderCellSorting,
                  selectedOrderBy: _orderBy,
                ),
                FileExplorerTableHeaderCell(
                  isLoading: _listFilesInProgress,
                  title: 'Date',
                  orderBy: OrderBy.modTime,
                  selectedOrderDir: _orderDir,
                  onTap: _handleTableHeaderCellSorting,
                  selectedOrderBy: _orderBy,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
