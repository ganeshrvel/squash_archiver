import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_column_definition_store.dart';

class FileExplorerTableHeader extends StatelessWidget {
  const FileExplorerTableHeader({
    super.key,
    required this.colDefs,
    required this.orderBy,
    required this.orderDir,
    this.onColumnHeaderTap,
  });

  final List<FileExplorerTableColumnDefinitionStore> colDefs;

  final Function(FileExplorerTableColumnDefinitionStore)? onColumnHeaderTap;

  final OrderBy? orderBy;

  final OrderDir? orderDir;

  static const double horizontalPadding = 10;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: [
        const FixedColumnWidth(horizontalPadding),
        ...colDefs.map((colDef) => colDef.width),
        const FixedColumnWidth(horizontalPadding),
      ].asMap(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            const SizedBox.shrink(),
            ...colDefs.asMap().keys.map((index) {
              final colDef = colDefs[index];
              final isOrderedByThisColumn =
                  colDef.columnSortIdentifier != null &&
                      colDef.columnSortIdentifier == orderBy;

              var labelStyle = MacosTheme.of(context).typography.headline;
              labelStyle = labelStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: labelStyle.color?.withOpacity(0.6),
              );
              if (isOrderedByThisColumn) {
                labelStyle = labelStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: labelStyle.color?.withOpacity(1),
                );
              }

              Widget orderDirectionArrow = const SizedBox(
                width: 16,
                height: 16,
              );
              if (isOrderedByThisColumn) {
                orderDirectionArrow = CustomPaint(
                  size: const Size.square(16),
                  painter: _SortDirectionCaretPainter(
                    color: MacosTheme.of(context).brightness.resolve(
                          MacosColors.disabledControlTextColor.color,
                          MacosColors.disabledControlTextColor.darkColor,
                        ),
                    orderDir: orderDir,
                  ),
                );
              }

              return GestureDetector(
                /// if [colDef.columnSortIdentifier] null then disable column sorting
                onTap: (colDef.columnSortIdentifier == null)
                    ? null
                    : (onColumnHeaderTap != null)
                        ? () => onColumnHeaderTap?.call(colDef)
                        : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: (index == colDefs.length - 1)
                            ? BorderSide.none
                            : BorderSide(
                                color: MacosTheme.of(context).dividerColor,
                              ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      child: Row(
                        children: [
                          Text(colDef.label, style: labelStyle),
                          const Spacer(),
                          orderDirectionArrow,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox.shrink(),
          ],
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: MacosTheme.of(context).dividerColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SortDirectionCaretPainter extends CustomPainter {
  const _SortDirectionCaretPainter({
    required this.color,
    required this.orderDir,
  });

  final Color color;
  final OrderDir? orderDir;

  @override
  void paint(Canvas canvas, Size size) {
    final hPadding = size.height / 3;

    switch (orderDir) {
      case OrderDir.desc:
        final p1 = Offset(hPadding, size.height / 2 - 1.0);
        final p2 = Offset(size.width / 2, size.height / 2 + 2.0);
        final p3 = Offset(size.width / 2 + 1.0, size.height / 2 + 1.0);
        final p4 = Offset(size.width - hPadding, size.height / 2 - 1.0);
        final paint = Paint()
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1.75;
        canvas.drawLine(p1, p2, paint);
        canvas.drawLine(p3, p4, paint);
        break;
      case OrderDir.asc:
        final p1 = Offset(hPadding, size.height / 2 + 1.0);
        final p2 = Offset(size.width / 2, size.height / 2 - 2.0);
        final p3 = Offset(size.width / 2 + 1.0, size.height / 2 - 1.0);
        final p4 = Offset(size.width - hPadding, size.height / 2 + 1.0);
        final paint = Paint()
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1.75;
        canvas.drawLine(p1, p2, paint);
        canvas.drawLine(p3, p4, paint);
        break;

      case null:
      case OrderDir.none:
        break;
    }
  }

  @override
  bool shouldRepaint(_SortDirectionCaretPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_SortDirectionCaretPainter oldDelegate) => false;
}
