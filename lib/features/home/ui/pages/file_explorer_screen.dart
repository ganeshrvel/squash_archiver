import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/pages/widgets/file_explorer_table.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/filesizes.dart';
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
              Observer(
                builder: (_) {
                  final _listFilesInProgress =
                      _fileExplorerScreenStore.listFilesInProgress;

                  return Button(
                    text: 'Refresh',
                    onPressed: () {
                      _fileExplorerScreenStore.refreshFiles();
                    },
                    buttonType: ButtonTypes.ICON,
                    icon: Icons.refresh,
                    iconButtonPadding: const EdgeInsets.all(20),
                    loading: _listFilesInProgress,
                  );
                },
              ),
              Observer(
                builder: (_) {
                  final _listFilesInProgress =
                      _fileExplorerScreenStore.listFilesInProgress;

                  return Button(
                    text: 'Force refresh',
                    onPressed: () {
                      _fileExplorerScreenStore.refreshFiles(
                        invalidateCache: true,
                      );
                    },
                    buttonType: ButtonTypes.ICON,
                    icon: Icons.replay_circle_filled,
                    iconButtonPadding: const EdgeInsets.all(20),
                    loading: _listFilesInProgress,
                  );
                },
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

  List<Widget> _buildRows({@required List<ArchiveFileInfo> fileList}) {
    return fileList.map((file) {
      return Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons == 2) {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                event.position.dx,
                event.position.dy,
                event.position.dx,
                event.position.dy,
              ),
              items: const <PopupMenuItem<String>>[
                PopupMenuItem(value: 'test1', child: Textography('test1')),
                PopupMenuItem(value: 'test2', child: Textography('test2')),
              ],
            );
          }
        },
        child: MouseRegion(
          child: GestureDetector(
            onDoubleTap: () {
              print(file);
            },
            child: ListTile(
              mouseCursor: SystemMouseCursors.basic,
              hoverColor: AppColors.transparent,
              focusColor: AppColors.transparent,
              selectedTileColor: AppColors.blue,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Textography(file.name),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Textography(filesize(file.size)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Textography(file.mode.toString()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildFileExplorer() {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        // if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        //
        // }
        // if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        //
        // }
      },
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

                return FilExplorerTable(
                  rows: _buildRows(fileList: _fileList),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Row(
      children: [
        _buildSidebar(),
        Expanded(
          child: _buildFileExplorer(),
        ),
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
