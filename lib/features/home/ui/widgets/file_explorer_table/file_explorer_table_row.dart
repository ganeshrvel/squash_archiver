import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/features/app/ui/store/app_store.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_column_definition_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_datasource_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/models/file_explorer_table_row_entity.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/inkwell/inkwell_extended.dart';

class FileExplorerTableRow extends StatefulWidget {
  final Map<int, TableColumnWidth> columnWidths;

  final List<FileExplorerTableColumnDefinitionStore> colDefs;

  final FileExplorerTableRowEntityGroup rowValueGroup;

  final FileExplorerTableDataSourceStore fileExplorerTableDataSourceStore;

  final double rowHeight;

  final int index;

  final Function({
    required FileExplorerTableRowEntity row,
    required int index,
  }) onTap;

  final Function({
    required FileExplorerTableRowEntity row,
    required int index,
  }) onDoubleTap;

  final Map<String, FileListingResponse> selectedRows;

  const FileExplorerTableRow({
    super.key,
    required this.index,
    required this.columnWidths,
    required this.colDefs,
    required this.rowValueGroup,
    required this.rowHeight,
    required this.onTap,
    required this.onDoubleTap,
    required this.fileExplorerTableDataSourceStore,
    required this.selectedRows,
  });

  @override
  State<StatefulWidget> createState() => _FileExplorerTableRowState();
}

class _FileExplorerTableRowState extends SfWidget<FileExplorerTableRow> {
  FileExplorerTableDataSourceStore get _fileExplorerTableDataSourceStore =>
      widget.fileExplorerTableDataSourceStore;

  AppStore get _appStore => getIt<AppStore>();

  // Getters for each parameter
  Map<int, TableColumnWidth> get columnWidths => widget.columnWidths;

  List<FileExplorerTableColumnDefinitionStore> get colDefs => widget.colDefs;

  FileExplorerTableRowEntityGroup get rowValueGroup => widget.rowValueGroup;

  double get rowHeight => widget.rowHeight;

  int get index => widget.index;

  Map<String, FileListingResponse> get selectedRows => widget.selectedRows;

  Function({
    required FileExplorerTableRowEntity row,
    required int index,
  }) get onTap => widget.onTap;

  Function({
    required FileExplorerTableRowEntity row,
    required int index,
  }) get onDoubleTap => widget.onDoubleTap;

  bool get highlightOddRow => widget.index.isOdd;

  @override
  Widget build(BuildContext context) {
    return InkWellExtended(
      onTap: () {
        onTap(
          row: rowValueGroup.row,
          index: index,
        );
      },
      onDoubleTap: () {
        onDoubleTap(
          row: rowValueGroup.row,
          index: index,
        );
      },
      child: ColoredBox(
        // we add a near transparent background color to make the whole column clickable
        color: MacosColors.white.withOpacity(0.00001),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Builder(
            builder: (context) {
              final isSelected = selectedRows.containsKey(
                rowValueGroup.row.rowKey,
              );

              return _RowHighlight(
                rowValueGroup: rowValueGroup,
                oddRow: highlightOddRow,
                isSelected: isSelected,
                columnWidths: columnWidths,
                children: colDefs.map(
                  (colDef) {
                    final AlignmentGeometry alignmentGeometry =
                        (colDef.alignment == ColumnAlignment.start)
                            ? Alignment.centerLeft
                            : (colDef.alignment == ColumnAlignment.center)
                                ? Alignment.center
                                : Alignment.centerRight;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox.fromSize(
                        size: Size(0, rowHeight),
                        child: Align(
                          alignment: alignmentGeometry,
                          child: colDef.cellBuilder(
                            context,
                            rowValueGroup.row.value,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Add selection and even / odd highlighting to table rows
class _RowHighlight extends StatelessWidget {
  const _RowHighlight({
    required this.rowValueGroup,
    required this.oddRow,
    required this.isSelected,
    required this.columnWidths,
    required this.children,
  });

  final FileExplorerTableRowEntityGroup rowValueGroup;
  final bool oddRow;
  final bool isSelected;
  final Map<int, TableColumnWidth> columnWidths;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rowBorderRadius = BorderRadius.circular(5);
    const rowRadius = Radius.circular(5);

    Decoration? decoration;
    var textStyle = MacosTheme.of(context)
        .typography
        .body
        .copyWith(fontFeatures: [const FontFeature.tabularFigures()]);
    if (oddRow && !isSelected) {
      decoration = BoxDecoration(
        color: MacosTheme.brightnessOf(context).resolve(
          const Color.fromRGBO(244, 245, 245, 1),
          const Color.fromRGBO(48, 48, 48, 1),
        ),
        borderRadius: rowBorderRadius,
      );
    } else if (isSelected) {
      BorderRadius? borderRadius;

      final isNextRowSelected =
          rowValueGroup.nextRow != null && rowValueGroup.nextRow!.isSelected();
      final isPrevRowSelected =
          rowValueGroup.prevRow != null && rowValueGroup.prevRow!.isSelected();

      if (isPrevRowSelected && isNextRowSelected) {
        borderRadius = BorderRadius.zero;
      } else {
        if (rowValueGroup.nextRow != null &&
            rowValueGroup.nextRow!.isSelected()) {
          borderRadius = const BorderRadius.only(
            topLeft: rowRadius,
            topRight: rowRadius,
          );
        }

        if (rowValueGroup.prevRow != null &&
            rowValueGroup.prevRow!.isSelected()) {
          borderRadius = const BorderRadius.only(
            bottomLeft: rowRadius,
            bottomRight: rowRadius,
          );
        }
      }

      borderRadius ??= const BorderRadius.all(
        rowRadius,
      );

      final bgColor = oddRow
          ? MacosTheme.of(context).primaryColor
          : MacosTheme.of(context).primaryColor.withOpacity(0.91);

      decoration = BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
      );
      textStyle = textStyle.copyWith(color: MacosColors.white);
    }
    return DefaultTextStyle(
      style: textStyle,
      child: Table(
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: decoration,
            children: children,
          ),
        ],
      ),
    );
  }
}
