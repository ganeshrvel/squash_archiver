import 'package:flutter/material.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

class FilExplorerTable<T> extends StatefulWidget {
  final List<Widget> rows;
  final List<Widget> columns;

  const FilExplorerTable({
    Key key,
    this.rows,
    this.columns,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilExplorerTableState();
}

class _FilExplorerTableState<T> extends SfWidget<FilExplorerTable> {
  List<Widget> get _rows => widget.rows;

  List<Widget> get _columns => widget.columns;

  int get _rowsLength => _rows.length;

  int get _columnsLength => _columns.length;

  @override
  Widget build(BuildContext context) {
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
  }
}
