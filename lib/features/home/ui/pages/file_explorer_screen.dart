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
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_toolbar.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_sidebar.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/overlays/progress_overlay.dart';
import 'package:squash_archiver/widgets/sliver/app_sliver_header.dart';

class FileExplorerScreen extends StatefulWidget {
  /// this is a dummy variable
  /// this is to assist auto argument generation
  final String dummy;

  const FileExplorerScreen({
    Key key,
    this.dummy,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends SfWidget<FileExplorerScreen> {
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
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    disposeStore(_disposers);

    super.dispose();
  }

  SliverPersistentHeader _buildToolbar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverHeader(
        child: FileExplorerToolbar(
          fileExplorerScreenStore: _fileExplorerScreenStore,
        ),
        maximumExtent: 55,
        minimumExtent: 50,
      ),
    );
  }

  Widget _buildSidebar() {
    return SizedBox(
      width: 250,
      //todo add a store for current path
      child: FileExplorerSidebar(
        fileExplorerScreenStore: _fileExplorerScreenStore,
      ),
    );
  }

  SliverPersistentHeader _buildTableHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverHeader(
        child: FileExplorerTableHeader(
          fileExplorerScreenStore: _fileExplorerScreenStore,
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
          padding: EdgeInsets.zero,
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
        Observer(
          builder: (_) {
            final _fileListingInProgress =
                _fileExplorerScreenStore.fileListingInProgress;

            return  ProgressOverlay(
              visible: _fileListingInProgress,
              loadingText: 'Loading file...',
            );
          },
        )
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
