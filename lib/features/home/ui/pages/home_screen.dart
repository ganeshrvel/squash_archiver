import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/ui/pages/home_screen_states.dart';
import 'package:squash_archiver/utils/archiver/archiver.dart';
import 'package:squash_archiver/utils/utils/filesizes.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/sliver/app_sliver_header.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

final _currentHelloWorld = ScopedProvider<String>(null);

class HomeScreen extends HookWidget {
  final String routeName;
  final Object routeArgs;

  const HomeScreen({
    this.routeName,
    this.routeArgs,
  });

  Archiver get _archiver => getIt<Archiver>();

  @override
  Widget build(BuildContext context) {
    final _scrollController = useScrollController();

    final _fileListFuture = useProvider(fileListProvider);
    final _currentPathState = useProvider(currentPathProvider);

    SliverPersistentHeader _buildHeader(BuildContext context) {
      return SliverPersistentHeader(
        pinned: true,
        delegate: AppSliverHeader(
          child: Padding(
            padding: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Button(
                  text: 'Back',
                  onPressed: () {
                    _currentPathState.prevPath();
                  },
                  buttonType: ButtonTypes.ICON,
                  icon: Icons.arrow_back,
                  iconButtonPadding: const EdgeInsets.all(20),
                ),
                Button(
                  text: 'Refresh',
                  onPressed: () {},
                  buttonType: ButtonTypes.ICON,
                  icon: Icons.refresh,
                  iconButtonPadding: const EdgeInsets.all(20),
                ),
                Button(
                  text: 'Force refresh',
                  onPressed: () {},
                  buttonType: ButtonTypes.ICON,
                  icon: Icons.replay_circle_filled,
                  iconButtonPadding: const EdgeInsets.all(20),
                ),
                Button(
                  text: 'Dummy',
                  onPressed: () {},
                  buttonType: ButtonTypes.ICON,
                  icon: Icons.refresh,
                  iconButtonPadding: const EdgeInsets.all(20),
                ),
                Button(
                  text: 'Dummy',
                  onPressed: () {},
                  buttonType: ButtonTypes.ICON,
                  icon: Icons.refresh,
                  iconButtonPadding: const EdgeInsets.all(20),
                ),
                Button(
                  text: 'Dummy',
                  onPressed: () {},
                  buttonType: ButtonTypes.ICON,
                  icon: Icons.refresh,
                  iconButtonPadding: const EdgeInsets.all(20),
                ),
                Button(
                  text: 'Dummy',
                  onPressed: () {},
                  buttonType: ButtonTypes.ICON,
                  icon: Icons.refresh,
                  iconButtonPadding: const EdgeInsets.all(20),
                ),
              ],
            ),
          ),
          maximumExtent: 100,
          minimumExtent: 70,
        ),
      );
    }

    Widget _buildSidebar(BuildContext context) {
      return SizedBox(
        width: 300,
        child: Container(
          padding: const EdgeInsets.only(top: 100),
          color: AppColors.blue,
          child: Column(
            children: [
              Button(
                text: 'Home Directory',
                onPressed: () {},
                buttonType: ButtonTypes.FLAT,
                icon: Icons.home,
                roundedEdge: false,
              ),
              Button(
                text: 'Home Directory',
                onPressed: () {},
                buttonType: ButtonTypes.FLAT,
                icon: Icons.home,
                roundedEdge: false,
              ),
              Button(
                text: 'Home Directory',
                onPressed: () {},
                buttonType: ButtonTypes.FLAT,
                icon: Icons.home,
                roundedEdge: false,
              ),
              Button(
                text: 'Home Directory',
                onPressed: () {},
                buttonType: ButtonTypes.FLAT,
                icon: Icons.home,
                roundedEdge: false,
              ),
            ],
          ),
        ),
      );
    }

    List<DataRow> _buildTableRows(BuildContext context) {
      final _dataCell = <DataRow>[];

      _fileListFuture.when(
        data: (data) {
          for (var i = 0; i < data.length; i++) {
            _dataCell.add(
              DataRow(
                  key: ValueKey(data[i].fullPath),
                  cells: <DataCell>[
                    DataCell(Row(
                      children: [
                        if (data[i].isDir)
                          Icon(
                            Icons.folder,
                            color: AppColors.blue,
                          )
                        else
                          const Icon(Icons.file_copy_rounded),
                        const SizedBox(width: 10),
                        Textography(data[i].name),
                      ],
                    )),
                    DataCell(
                      Textography(filesize(data[i].size)),
                    ),
                    DataCell(
                      Textography(
                        DateTime.parse(data[i].modTime).toLocal().toString(),
                      ),
                    ),
                    DataCell(
                      Textography(data[i].mode.toString()),
                    ),
                  ],
                  onSelectChanged: (changed) {
                    if (!data[i].isDir) {
                      return;
                    }

                    _currentPathState.setPath(data[i].fullPath);
                  }),
            );
          }
        },
        loading: () {
          _dataCell.add(const DataRow(cells: <DataCell>[
            DataCell(
              Textography('Loading...'),
            ),
            DataCell(
              Textography('Loading...'),
            ),
            DataCell(
              Textography('Loading...'),
            ),
            DataCell(
              Textography('Loading...'),
            ),
          ]));
        },
        error: (_, __) {
          _dataCell.add(const DataRow(cells: <DataCell>[
            DataCell(
              Textography('...'),
            ),
            DataCell(
              Textography('Error...'),
            ),
            DataCell(
              Textography('Error...'),
            ),
            DataCell(
              Textography('Error...'),
            ),
          ]));
        },
      );

      return <DataRow>[..._dataCell];
    }

    Widget _buildFileExplorer(BuildContext context) {
      return Expanded(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const ScrollPhysics(),
          slivers: <Widget>[
            _buildHeader(context),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    DataTable(
                      showCheckboxColumn: false,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Textography(
                            'Name',
                          ),
                        ),
                        DataColumn(
                          label: Textography(
                            'Size',
                          ),
                        ),
                        DataColumn(
                          label: Textography(
                            'Modified Date',
                          ),
                        ),
                        DataColumn(
                          label: Textography(
                            'Permission',
                          ),
                        ),
                      ],
                      rows: _buildTableRows(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildBody(BuildContext context) {
      return Row(
        children: [
          _buildSidebar(context),
          _buildFileExplorer(context),
        ],
      );
    }

    return SafeArea(
      top: true,
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }
}
