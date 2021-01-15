import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart' show ReactionDisposer;
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_pane.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table_header.dart';
import 'package:squash_archiver/features/home/ui/widgets/sidebar.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/shadows/box_shadow_1.dart';
import 'package:squash_archiver/widgets/sliver/app_sliver_header.dart';

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

  List<ReactionDisposer> _disposers;

  ScrollController _scrollController;

  @override
  void initState() {
    _fileExplorerScreenStore ??= FileExplorerScreenStore();
    _scrollController ??= ScrollController();

    super.initState();
  }

  @override
  void onInitApp() {
    _init();

    super.onInitApp();
  }

  void _init() {
    _fileExplorerScreenStore.navigateToSource(
      fullPath: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
      source: FileExplorerSource.LOCAL,
      clearStack: true,
    );
  }

  @override
  void didChangeDependencies() {
    // _disposers ??= [
    //   reaction(
    //     (_) => _fileExplorerScreenStore.currentArchiveFilepath,
    //     (String currentArchiveFilepath) {
    //       // if (isNullOrEmpty(currentArchiveFilepath)) {
    //       //   _fileExplorerScreenStore.setFiles([]);
    //       //   _fileExplorerScreenStore.setPassword('');
    //       //   _fileExplorerScreenStore.setCurrentPath('');
    //       //
    //       //   return;
    //       // }
    //
    //       // _fileExplorerScreenStore.fetchFiles();
    //     },
    //   ),
    //   reaction(
    //     (_) => _fileExplorerScreenStore.orderBy,
    //     (OrderBy orderBy) {
    //       // _fileExplorerScreenStore.fetchFiles();
    //     },
    //   ),
    //   reaction(
    //     (_) => _fileExplorerScreenStore.orderDir,
    //     (OrderDir orderDir) {
    //       // _fileExplorerScreenStore.fetchFiles();
    //     },
    //   ),
    //   reaction(
    //     (_) => _fileExplorerScreenStore.currentPath,
    //     (String currentPath) {
    //       // _fileExplorerScreenStore.fetchFiles();
    //     },
    //   ),
    //   reaction(
    //     (_) => _fileExplorerScreenStore.gitIgnorePattern,
    //     (List<String> gitIgnorePattern) {
    //       //_fileExplorerScreenStore.fetchFiles();
    //     },
    //   ),
    // ];

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    disposeStore(_disposers);

    super.dispose();
  }

  void _handleTableHeaderCellSorting({
    @required OrderDir orderDir,
    @required OrderBy orderBy,
  }) {
    _fileExplorerScreenStore.setOrderDirOrderBy(
      orderBy: orderBy,
      orderDir: orderDir,
    );
  }

  SliverPersistentHeader _buildToolbar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverHeader(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow5(),
            ],
          ),
          padding: EdgeInsets.zero,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Observer(
                  builder: (_) {
                    final _listFilesInProgress =
                        _fileExplorerScreenStore.fileListingInProgress;

                    return Button(
                      text: 'Back',
                      onPressed: () {
                        _fileExplorerScreenStore.gotoPrevDirectory();
                      },
                      buttonType: ButtonType.ICON,
                      icon: Icons.arrow_back,
                      iconButtonPadding: const EdgeInsets.all(20),
                      loading: _listFilesInProgress,
                    );
                  },
                ),
                Observer(
                  builder: (_) {
                    final _listFilesInProgress =
                        _fileExplorerScreenStore.fileListingInProgress;

                    return Button(
                      text: 'Refresh',
                      onPressed: () {
                        _fileExplorerScreenStore.refreshFiles();
                      },
                      buttonType: ButtonType.ICON,
                      icon: Icons.refresh,
                      iconButtonPadding: const EdgeInsets.all(20),
                      loading: _listFilesInProgress,
                    );
                  },
                ),
                Observer(
                  builder: (_) {
                    final _listFilesInProgress =
                        _fileExplorerScreenStore.fileListingInProgress;

                    return Button(
                      text: 'Force refresh',
                      onPressed: () {
                        _fileExplorerScreenStore.refreshFiles(
                          invalidateCache: true,
                        );
                      },
                      buttonType: ButtonType.ICON,
                      icon: Icons.replay_circle_filled,
                      iconButtonPadding: const EdgeInsets.all(20),
                      loading: _listFilesInProgress,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        maximumExtent: 70,
        minimumExtent: 50,
      ),
    );
  }

  Widget _buildSidebar() {
    return SizedBox(
      width: 250,
      //todo add a store for current path
      child: Sidebar(
        fileExplorerScreenStore: _fileExplorerScreenStore,
      ),
    );
  }

  SliverPersistentHeader _buildTableHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverHeader(
        child: Container(
          padding: EdgeInsets.zero,
          color: AppColors.white,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Observer(
                  builder: (_) {
                    final _orderDir = _fileExplorerScreenStore.orderDir;
                    final _listFilesInProgress =
                        _fileExplorerScreenStore.fileListingInProgress;

                    return FileExplorerTableHeaderCell(
                      isLoading: _listFilesInProgress,
                      title: 'Name',
                      orderBy: OrderBy.name,
                      currentOrderDir: _orderDir,
                      onTap: _handleTableHeaderCellSorting,
                    );
                  },
                ),
                Observer(
                  builder: (_) {
                    final _orderDir = _fileExplorerScreenStore.orderDir;
                    final _listFilesInProgress =
                        _fileExplorerScreenStore.fileListingInProgress;

                    return FileExplorerTableHeaderCell(
                      isLoading: _listFilesInProgress,
                      title: 'Size',
                      orderBy: OrderBy.size,
                      currentOrderDir: _orderDir,
                      onTap: _handleTableHeaderCellSorting,
                    );
                  },
                ),
                Observer(
                  builder: (_) {
                    final _orderDir = _fileExplorerScreenStore.orderDir;
                    final _listFilesInProgress =
                        _fileExplorerScreenStore.fileListingInProgress;

                    return FileExplorerTableHeaderCell(
                      isLoading: _listFilesInProgress,
                      title: 'Date',
                      orderBy: OrderBy.modTime,
                      currentOrderDir: _orderDir,
                      onTap: _handleTableHeaderCellSorting,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        maximumExtent: 30,
        minimumExtent: 30,
      ),
    );
  }

  Widget _buildFileExplorerPane() {
    return FileExplorerPane(
      fileExplorerScreenStore: _fileExplorerScreenStore,
    );
  }

  Widget _buildFileExplorer() {
    return Expanded(
      child: RawKeyboardListener(
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
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          color: AppColors.white,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const ScrollPhysics(),
            slivers: <Widget>[
              _buildToolbar(),
              _buildTableHeader(),
              _buildFileExplorerPane(),
            ],
          ),
        ),
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
        backgroundColor: Colors.transparent,
        body: _buildBody(),
      ),
    );
  }
}
