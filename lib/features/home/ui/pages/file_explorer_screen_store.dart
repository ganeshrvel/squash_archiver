import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';

///
/// This is an app wide store
///
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/utils/archiver/archiver.dart';
import 'package:squash_archiver/utils/utils/files.dart';
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

  @computed
  bool get listFilesInProgress {
    return isStateLoading(fileListFuture);
  }

  @action
  Future<void> fetchFiles({bool invalidateCache}) async {
    final _invalidateCache = invalidateCache ?? false;

    var _currentPath = currentPath;
    if (_invalidateCache) {
      // [listDirectoryPath] should be left empty while invalidating the cache to assist the refetch of the whole archive again

      _currentPath = '';
      setCurrentPath('');
    }

    final _params = ListArchive(
      filename: currentArchiveFilename,
      recursive: true,
      listDirectoryPath: _currentPath,
      password: password,
      gitIgnorePattern: gitIgnorePattern,
      orderBy: orderBy,
      orderDir: orderDir,
    );

    fileListException = null;

    fileListFuture = ObservableFuture(
      _archiver.listFiles(
        _params,
        invalidateCache: _invalidateCache,
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
  Future<void> refreshFiles({bool invalidateCache}) async {
    return fetchFiles(invalidateCache: invalidateCache);
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
