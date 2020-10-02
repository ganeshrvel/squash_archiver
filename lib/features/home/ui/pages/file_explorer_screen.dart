import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/sliver/app_sliver_header.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerScreen extends StatefulWidget {
  final String redirectRouteName;
  final Object redirectRouteArgs;

  const FileExplorerScreen({
    Key key,
    this.redirectRouteName,
    this.redirectRouteArgs,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FileExplorerScreenState();
}

// class FileExplorerScreen extends HookWidget implements SfWidget<AlertsScreen> {
class _FileExplorerScreenState extends SfWidget<FileExplorerScreen> {
  String get _redirectRouteName => widget.redirectRouteName;

  Object get _redirectRouteArgs => widget.redirectRouteArgs;

  FileExplorerScreenStore _fileExplorerScreenStore;

  ScrollController _scrollController;

  @override
  void initState() {
    _fileExplorerScreenStore ??= FileExplorerScreenStore();
    _scrollController ??= ScrollController();

    _init();
    super.initState();
  }

  void _init() {
    _fileExplorerScreenStore.setCurrentArchiveFilename(
      getDesktopFile('squash-test-assets/huge_file.zip'),
    );
  }

  @override
  void dispose() {
    disposeStore(_fileExplorerScreenStore.disposers);

    super.dispose();
  }

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
                  _fileExplorerScreenStore.gotoPrevDirectory();
                },
                buttonType: ButtonTypes.ICON,
                icon: Icons.arrow_back,
                iconButtonPadding: const EdgeInsets.all(20),
              ),
              Button(
                text: 'Refresh',
                onPressed: () {
                  _fileExplorerScreenStore.refreshFiles();
                },
                buttonType: ButtonTypes.ICON,
                icon: Icons.refresh,
                iconButtonPadding: const EdgeInsets.all(20),
              ),
              Button(
                text: 'Force refresh',
                onPressed: () {
                  _fileExplorerScreenStore.refreshFiles(
                    invalidateCache: true,
                  );
                },
                buttonType: ButtonTypes.ICON,
                icon: Icons.replay_circle_filled,
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

  Widget _buildSidebar() {
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

  // Widget _buildFileExplorer({
  //   @required List<ArchiveFileInfo> fileList,
  // }) {
  //   return FileExplorerTable(
  //     fileList: fileList,
  //   );
  // }

  //
  // Widget _buildFileExplorer() {
  //   return CustomScrollView(
  //     controller: _scrollController,
  //     physics: const ScrollPhysics(),
  //     slivers: <Widget>[
  //       _buildHeader(context),
  //       SliverPadding(
  //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
  //         sliver: Observer(
  //           builder: (_) {
  //             final _fileList = _fileExplorerScreenStore.fileList;
  //
  //             return SliverList(
  //               delegate: SliverChildListDelegate(
  //                 [
  //                   ListView.builder(
  //                       itemCount: _fileList.length,
  //                       itemBuilder: (BuildContext ctxt, int index) {
  //                         return Text(_fileList[index].name);
  //                       })
  //
  //                   // Padding(
  //                   //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
  //                   //   child: _buildFileExplorer(
  //                   //     fileList: _fileList,
  //                   //   ),
  //                   // ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFileExplorer() {
    return Expanded(
      child: CustomScrollView(
        controller: _scrollController,
        physics: const ScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            sliver: Observer(
              builder: (_) {
                final _fileList = _fileExplorerScreenStore.fileList;

                // return SliverList(
                //   delegate: SliverChildListDelegate([
                //     FileExplorerTable(
                //       fileList: _fileList,
                //     )
                //   ]),
                // );

                ///
                /// TODO use this:
                ///
                ///
                return SliverList(
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    if (index >= _fileList.length) {
                      return null;
                    }

                    // To convert this infinite list to a list with three items,
                    // uncomment the following line:
                    // if (index > 3) return null;
                    return Textography(_fileList[index].name);
                  }),
                );

                ///
                /// TODO use this^
                ///

                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // Container(color: Colors.red, height: 150.0),
                      // Container(color: Colors.purple, height: 150.0),
                      // Container(color: Colors.green, height: 150.0),
                      // FileExplorerTable(
                      //   fileList: _fileList,
                      // ),
                      // ListView.builder(
                      //     itemCount: _fileList.length,
                      //     itemBuilder: (BuildContext ctxt, int index) {
                      //       return Text(_fileList[index].name);
                      //     })

                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      //   child: _buildFileExplorer(
                      //     fileList: _fileList,
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
            // sliver: SliverList(
            //   delegate: SliverChildListDelegate(
            //     [
            //
            //       ListView.builder(
            //         itemCount: _fileList.length,
            //         itemBuilder: (BuildContext ctxt, int index) {
            //           return Text(_fileList[index].name);
            //         },),
            //
            //     ],
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Row(
      children: [
        _buildSidebar(),
        _buildFileExplorer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }
}
