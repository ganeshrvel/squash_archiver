import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as path;
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/features/app/ui/store/app_store.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_explorer_toolbar_entiry.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_password_overlay.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table/file_explorer_table_delegate.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_toolbar_actions.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_toolbar_leading.dart';
import 'package:squash_archiver/helpers/provider_helpers.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/overlays/progress_overlay.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class FileExplorerScaffold extends StatefulWidget {
  final FocusNode fileExplorerFocusNode;

  const FileExplorerScaffold({
    super.key,
    required this.fileExplorerFocusNode,
  });

  @override
  State<FileExplorerScaffold> createState() => _FileExplorerScaffoldState();
}

class _FileExplorerScaffoldState extends SfWidget<FileExplorerScaffold> {
  FileExplorerScreenStore get _fileExplorerScreenStore =>
      readProvider<FileExplorerScreenStore>(context);

  AppStore get _appStore => getIt<AppStore>();

  FocusNode get _fileExplorerFocusNode => widget.fileExplorerFocusNode;

  void _handlePasswordRequestOkTap({
    required FileListingRequest fileListingRequest,
    required String password,
  }) {
    _fileExplorerScreenStore.navigateToSource(
      fullPath: fileListingRequest.path,
      password: password,
      clearStack: false,
      source: FileExplorerSource.ARCHIVE,
      currentArchiveFilepath: fileListingRequest.archiveFilepath,
      orderBy: fileListingRequest.orderBy,
      orderDir: fileListingRequest.orderDir,
      gitIgnorePattern: fileListingRequest.gitIgnorePattern,
    );

    _fileExplorerScreenStore.resetRequestPassword();
  }

  void _handlePasswordRequestCancelTap() {
    _fileExplorerScreenStore.resetRequestPassword();
  }

  String _getTitle({required String currentPath}) {
    if (isNullOrEmpty(currentPath)) {
      return '';
    }

    return path.basename(currentPath);
  }

  List<FileExplorerToolbarItemEntity> _buildFileExplorerToolbarActions({
    required bool fileListingInProgress,
  }) {
    return [
      (
        label: 'Add',
        iconData: CupertinoIcons.add_circled,
        loading: fileListingInProgress,
        onPressed: () {
          // todo add to archive
        },
      ),
      (
        label: 'Extract',
        iconData: CupertinoIcons.arrow_down_doc,
        loading: fileListingInProgress,
        onPressed: () {
          // todo add to archive
        },
      ),
    ];
  }

  Widget _buildProgressOverlay() {
    return Observer(
      builder: (_) {
        final _archiveLoadingInProgress =
            _fileExplorerScreenStore.archiveLoadingInProgress;

        return ProgressOverlay(
          visible: _archiveLoadingInProgress, //_archiveLoadingInProgress,
          loadingText: 'Loading file...',
        );
      },
    );
  }

  Widget _buildPasswordOverlay({
    required ScrollController scrollController,
  }) {
    return Observer(
      builder: (_) {
        final _requestPassword = _fileExplorerScreenStore.requestPassword;
        final _showRequestPasswordOverlay = _requestPassword != null;

        if (!_showRequestPasswordOverlay) {
          return const SizedBox.shrink();
        }

        return FileExplorerPasswordOverlay(
          visible: _showRequestPasswordOverlay,
          passwordRequest: _requestPassword,
          onCancel: _handlePasswordRequestCancelTap,
          onOk: _handlePasswordRequestOkTap,
          invalidPassword: _requestPassword.invalidPassword,
          scrollController: scrollController,
        );
      },
    );
  }

  Widget _buildContentArea() {
    return ContentArea(
      builder: (_, scrollController) {
        return Stack(
          children: [
            FileExplorerTableDelegate(
              fileExplorerFocusNode: _fileExplorerFocusNode,
              fileExplorerScaffoldScrollController: scrollController,
            ),
            _buildProgressOverlay(),
            _buildPasswordOverlay(scrollController: scrollController),
          ],
        );
      },
    );
  }

  List<Widget> _buildBody() {
    return [
      _buildContentArea(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final _currentPath = _fileExplorerScreenStore.currentPath;
        final _fileListingInProgress =
            _fileExplorerScreenStore.fileListingInProgress;
        final _title = _getTitle(currentPath: _currentPath);

        final _entities = _buildFileExplorerToolbarActions(
          fileListingInProgress: _fileListingInProgress,
        );

        return MacosScaffold(
          backgroundColor: MacosTheme.brightnessOf(context).resolve(
            const Color.fromRGBO(255, 255, 255, 1),
            const Color.fromRGBO(43, 43, 43, 1),
          ),
          toolBar: ToolBar(
            titleWidth: 200,
            actions: FileExplorerToolbarActions.getActions(
              entities: _entities,
            ),
            title: Textography(
              _title,
              variant: TextVariant.Body,
              fontWeight: MacosFontWeight.w510,
            ),
            enableBlur: true,
            leading: const FileExplorerToolbarLeading(),
          ),
          children: _buildBody(),
        );
      },
    );
  }
}
