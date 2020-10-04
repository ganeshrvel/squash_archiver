import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:meta/meta.dart';

///
/// This is an app wide store
///
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/controllers/file_explorer_controller.dart';
import 'package:squash_archiver/features/home/data/data_sources/archiver_data_source.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
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
  final _archiverDataSource = getIt<ArchiverDataSource>();
  final _fileExplorerController = getIt<FileExplorerController>();

  @observable
  List<FileListingRequest> _fileListingRequestBucket = ObservableList();

  @computed
  FileListingRequest get _fileListingRequest {
    if (isNullOrEmpty(_fileListingRequestBucket)) {
      return FileListingRequest(
        currentPath: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
      );
    }

    return _fileListingRequestBucket.last;
  }

  //todo old -> @computed
  @observable
  String currentPath = '';

  //todo old -> @computed
  /// archiver [filename]
  @observable
  String currentArchiveFilename = '';

  //todo old -> @computed
  /// archiver [password]
  @observable
  String password = '';

  @observable
  OrderBy orderBy = AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY;

  //todo old -> @computed
  @observable
  OrderDir orderDir = AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR;

  //todo old -> @computed
  @observable
  List<String> gitIgnorePattern = ObservableList();

  //todo old -> @computed
  @observable
  ObservableFuture<DC<Exception, List<FileInfo>>> fileListFuture =
      ObservableFuture(Future.value());

  @observable
  Exception fileListException;

  //todo old -> @computed
  @observable
  List<FileInfo> fileList = ObservableList<FileInfo>();

  @computed
  bool get listFilesInProgress {
    return isStateLoading(fileListFuture);
  }

  //todo old
  @action
  Future<void> _fetchFiles({bool invalidateCache}) async {
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
      _archiverDataSource.listFiles(
        listArchiveRequest: _params,
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

  //todo old
  @action
  Future<void> refreshFiles({bool invalidateCache}) async {
    return _fetchFiles(invalidateCache: invalidateCache);
  }

  @action
  Future<void> fetchFiles({
    @required FileListingRequest request,
    @required FileExplorerSource source,
    bool invalidateCache,
  }) async {
    fileListFuture = ObservableFuture(
      _fileExplorerController.listFiles(
        request: _fileListingRequest,
        source: source,
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
  Future<void> newSource({
    @required String fullPath,
    @required FileExplorerSource source,
  }) async {
    assert(fullPath != null);
    assert(source != null);

    // todo add toggle hidden files
    final _request = FileListingRequest(
      currentPath: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
      gitIgnorePattern: gitIgnorePattern,
      orderDir: orderDir,
      orderBy: orderBy,
    );

    _addFileListingRequestBucket(_request);

    //todo remove
    await fetchFiles(request: _request, source: source);
  }

  //todo old
  @action
  void setCurrentPath(String value) {
    assert(value != null);

    currentPath = value;
  }

  //todo old
  @action
  void gotoPrevDirectory() {
    currentPath = getParentPath(currentPath);
  }

  //todo old
  @action
  void setCurrentArchiveFilename(String value) {
    currentArchiveFilename = value;
  }

  //todo old
  @action
  void setPassword(String value) {
    password = value;
  }

  //todo old
  @action
  void setFiles(List<FileInfo> value) {
    fileList = value;
  }

  @action
  void _setFileListingRequestBucket(FileListingRequest param) {
    _fileListingRequestBucket = [param];
  }

  @action
  void _addFileListingRequestBucket(FileListingRequest param) {
    if (isNullOrEmpty(_fileListingRequestBucket)) {
      _setFileListingRequestBucket(param);

      return;
    }

    _fileListingRequestBucket.add(param);
  }
}
