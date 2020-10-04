import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';

///
/// This is an app wide store
///
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/utils/archiver/archiver.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';

part 'file_explorer_screen_store.g.dart';

class FileExplorerScreenStore = _FileExplorerScreenStoreBase
    with _$FileExplorerScreenStore;

// todo [chaining the explorer]  convert the whole fetchfiles params into a list.
// pick the last array index and that shall be the files displayed on the explorer window
// this way it is scalable and will support multitabs

abstract class _FileExplorerScreenStoreBase with Store {
  final Archiver _archiver = getIt<Archiver>();

  @observable
  String currentPath = '';

  /// archiver [filename]
  @observable
  String currentArchiveFilename = '';

  /// archiver [password]
  @observable
  String password = '';

  @observable
  ArchiverOrderBy orderBy = ArchiverOrderBy.fullPath;

  @observable
  ArchiverOrderDir orderDir = ArchiverOrderDir.none;

  @observable
  List<String> gitIgnorePattern = ObservableList();

  @observable
  ObservableFuture<DC<Exception, List<ArchiveFileInfo>>> fileListFuture =
      ObservableFuture(Future.value());

  @observable
  Exception fileListException;

  @observable
  List<ArchiveFileInfo> fileList = ObservableList<ArchiveFileInfo>();

  List<ReactionDisposer> get disposers => [
        reaction(
          (_) => currentArchiveFilename,
          (String currentArchiveFilename) {
            if (isNullOrEmpty(currentArchiveFilename)) {
              setFiles([]);
              setPassword('');
              setCurrentPath('');

              return;
            }

            fetchFiles();
          },
        )
      ];

  @computed
  bool get listFilesInProgress {
    return isStateLoading(fileListFuture);
  }

  @action
  Future<void> refreshFiles({bool invalidateCache}) async {
    return fetchFiles(invalidateCache: invalidateCache);
  }

  @action
  Future<void> fetchFiles({bool invalidateCache}) async {
    final _params = ListArchive(
      filename: currentArchiveFilename,
      recursive: true,
      listDirectoryPath: currentPath,
      password: password,
      gitIgnorePattern: gitIgnorePattern,
      orderBy: orderBy,
      orderDir: orderDir,
    );

    fileListException = null;

    fileListFuture = ObservableFuture(
      _archiver.listFiles(
        _params,
        invalidateCache: invalidateCache,
      ),
    );

    final _data = await fileListFuture;

    _data.pick(
      onError: (error) {
        fileListException = error;
      },
      onData: (data) {
        fileList = data;
      },
      onNoData: () {
        fileList = [];
      },
    );
  }

  @action
  void setCurrentPath(String value) {
    currentPath = value;
  }

  @action
  void gotoPrevDirectory() {
    currentPath = getParentPath(currentPath);
  }

  @action
  void setCurrentArchiveFilename(String value) {
    currentArchiveFilename = value;

    //todo remove this. fix this
    print('todo remove this. fix this');
    fetchFiles();
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setFiles(List<ArchiveFileInfo> value) {
    fileList = value;
  }
}
