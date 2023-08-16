import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mobx/mobx.dart' show ReactionDisposer, reaction;
import 'package:provider/provider.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_scaffold.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';
import 'package:squash_archiver/features/home/ui/widgets/file_explorer_sidebar.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

@RoutePage(name: 'FileExplorerScreenRoute')
class FileExplorerScreen extends StatefulWidget {
  /// this is a dummy variable
  /// this is to assist auto argument generation
  final String? dummy;

  const FileExplorerScreen({
    super.key,
    this.dummy,
  });

  @override
  State<StatefulWidget> createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends SfWidget<FileExplorerScreen> {
  late final FileExplorerScreenStore _fileExplorerScreenStore =
      FileExplorerScreenStore();

  late final FocusNode _fileExplorerFocusNode = FocusNode();

  late final List<ReactionDisposer> _disposers;

  @override
  void initState() {
    _disposers = [
      reaction(
        (_) => _fileExplorerScreenStore.fileContainersException,
        (Exception? fileContainersException) {
          if (isNull(fileContainersException)) {
            return;
          }

          throwException(context, fileContainersException!);
        },
      ),
    ];

    super.initState();
  }

  @override
  void onInitApp() {
    _init();

    super.onInitApp();
  }

  void _init() {
    _fileExplorerScreenStore.navigateToSource(
      fullPath: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY!,
      source: FileExplorerSource.LOCAL,
      clearStack: true,
    );
  }

  @override
  void dispose() {
    disposeStore(_disposers);
    _fileExplorerFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FileExplorerScreenStore>(
          create: (_) => _fileExplorerScreenStore,
        ),
      ],
      builder: (context, _) {
        return MacosWindow(
          sidebar: Sidebar(
            minWidth: 200,
            builder: (context, scrollController) {
              return FileExplorerSidebar(
                sidebarScrollController: scrollController,
              );
            },
          ),
          // todo a preview panel for info and other previews
          //endSidebar: ,
          child: FileExplorerScaffold(
            fileExplorerFocusNode: _fileExplorerFocusNode,
          ),
        );
      },
    );
  }
}
