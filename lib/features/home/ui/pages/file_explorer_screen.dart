import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart' show ReactionDisposer, reaction;
import 'package:provider/provider.dart';
import 'package:squash_archiver/common/helpers/file_explorer_key_modifiers_helper.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/constants/sizes.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/app/data/models/keyboard_modifier_intent.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_keyboard_modifiers_store.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_pane.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_password_overlay.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_table_header.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_toolbar.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_sidebar.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
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

  FileExplorerKeyboardModifiersStore _fileExplorerKeyboardModifiersStore;

  List<ReactionDisposer> _disposers;

  ScrollController _scrollController;

  FocusNode _fileExplorerFocusNode;

  ShortcutManager _shortcutManager;

  @override
  void initState() {
    _fileExplorerScreenStore ??= FileExplorerScreenStore();
    _fileExplorerKeyboardModifiersStore ??=
        FileExplorerKeyboardModifiersStore();
    _scrollController ??= ScrollController();
    _fileExplorerFocusNode ??= FocusNode();
    _shortcutManager ??= ShortcutManager();

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
    _disposers = [
      reaction(
        (_) => _fileExplorerScreenStore.fileContainersException,
        (Exception fileContainersException) {
          if (isNull(fileContainersException)) {
            return;
          }
        },
      ),
    ];

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    disposeStore(_disposers);

    super.dispose();
  }

  void _handlePasswordRequestOkTap({
    @required FileListingRequest fileListingRequest,
    @required String password,
  }) {
    _fileExplorerScreenStore.navigateToSource(
      fullPath: fileListingRequest.path,
      password: password,
      clearStack: false,
      source: FileExplorerSource.ARCHIVE,
      currentArchiveFilepath: fileListingRequest.archiveFilepath,
    );

    _fileExplorerScreenStore.resetRequestPassword();
  }

  void _handlePasswordRequestCancelTap() {
    _fileExplorerScreenStore.resetRequestPassword();
  }

  SliverPersistentHeader _buildToolbar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverHeader(
        child: const FileExplorerToolbar(),
        maximumExtent: 50,
        minimumExtent: 50,
      ),
    );
  }

  Widget _buildSidebar() {
    return const SizedBox(
      width: Sizes.SIDEBAR_WIDTH,
      child: FileExplorerSidebar(),
    );
  }

  SliverPersistentHeader _buildTableHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverHeader(
        child: const FileExplorerTableHeader(),
        maximumExtent: 30,
        minimumExtent: 30,
      ),
    );
  }

  Widget _buildFileExplorerPane() {
    return const FileExplorerPane();
  }

  Widget _buildFileExplorer() {
    return Expanded(
      child: Shortcuts(
        manager: _shortcutManager,
        shortcuts: getKeyModifiersShortcut(),
        child: Actions(
          actions: <Type, Action<Intent>>{
            KeyboardModifierIntent: CallbackAction<KeyboardModifierIntent>(
              onInvoke: (KeyboardModifierIntent intent) {
                return _fileExplorerKeyboardModifiersStore
                    .setActiveKeyboardModifierIntent(intent);
              },
            ),
          },
          child: Focus(
            onKey: (focus, keyEvent) {
              if (isNullOrEmpty(keyEvent.data.modifiersPressed)) {
                _fileExplorerKeyboardModifiersStore
                    .resetActiveKeyboardModifierIntent();
              }

              return false;
            },
            autofocus: true,
            focusNode: _fileExplorerFocusNode,
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
        ),
      ),
    );
  }

  Widget _buildProgressOverlay() {
    return Observer(
      builder: (_) {
        final _archiveLoadingInProgress =
            _fileExplorerScreenStore.archiveLoadingInProgress;

        return ProgressOverlay(
          visible: _archiveLoadingInProgress,
          loadingText: 'Loading file...',
        );
      },
    );
  }

  Widget _buildPasswordOverlay() {
    return Observer(
      builder: (_) {
        final _requestPassword = _fileExplorerScreenStore.requestPassword;
        final _showRequestPasswordOverlay = isNotNull(_requestPassword);

        if (!_showRequestPasswordOverlay) {
          return Container();
        }

        return FileExplorerPasswordOverlay(
          visible: _showRequestPasswordOverlay,
          passwordRequest: _requestPassword,
          onCancel: _handlePasswordRequestCancelTap,
          onOk: _handlePasswordRequestOkTap,
          invalidPassword: _requestPassword.invalidPassword,
        );
      },
    );
  }

  Widget _buildBody() {
    return MultiProvider(
      providers: [
        Provider<FileExplorerScreenStore>(
          create: (_) => _fileExplorerScreenStore,
        ),
        Provider<FileExplorerKeyboardModifiersStore>(
          create: (_) => _fileExplorerKeyboardModifiersStore,
        ),
      ],
      child: Row(
        children: [
          _buildSidebar(),
          _buildFileExplorer(),
          _buildProgressOverlay(),
          _buildPasswordOverlay(),
        ],
      ),
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
