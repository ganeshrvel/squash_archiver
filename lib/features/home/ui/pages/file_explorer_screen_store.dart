import 'dart:async';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:collection/collection.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/features/home/data/controllers/file_explorer_controller.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/app/data/models/keyboard_modifier_intent.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';

part 'file_explorer_screen_store.g.dart';

class FileExplorerScreenStore = _FileExplorerScreenStoreBase
    with _$FileExplorerScreenStore;

abstract class _FileExplorerScreenStoreBase with Store {
  final _fileExplorerController = getIt<FileExplorerController>();

  @observable
  List<FileListingResponse> fileContainers =
      ObservableList<FileListingResponse>();

  @observable
  ObservableFuture<DC<Exception, List<FileListingResponse>>>
      fileContainersFuture = ObservableFuture(Future.value());

  @observable
  Exception fileContainersException;

  @observable
  @visibleForTesting
  List<FileListingRequest> fileListingSourceStack = ObservableList();

  /// the selected files in the file explorer
  /// ///todo make selectedFiles a map instead of list inorder to make it o(1)
  @observable
  Map<String, FileListingResponse> selectedFiles =
      ObservableMap<String, FileListingResponse>();

  ///todo move [activeKeyboardModifierIntent] into a different store
  /// keyboard events
  @observable
  KeyboardModifierIntent activeKeyboardModifierIntent;

  @computed
  FileListingRequest get fileListingSource {
    if (isNullOrEmpty(fileListingSourceStack)) {
      return FileListingRequest(path: '');
    }

    return fileListingSourceStack.last;
  }

  @computed
  bool get fileListingInProgress {
    return isStateLoading(fileContainersFuture);
  }

  @computed
  bool get archiveLoadingInProgress {
    return fileListingInProgress && isNotNullOrEmpty(currentArchiveFilepath);
  }

  /// current path in the file explorer; path of the last item in [fileListingSourceStack]
  @computed
  String get currentPath {
    return fileListingSource.path;
  }

  /// full path to the currently opened archive file in the file explorer; [archiveFilepath] of the last item in [fileListingSourceStack]
  @computed
  String get currentArchiveFilepath {
    return fileListingSource.archiveFilepath;
  }

  /// password of the currently opened file in the file explorer (if any); [password] of the last item in [fileListingSourceStack]
  @computed
  String get password {
    return fileListingSource.password;
  }

  @computed
  OrderBy get orderBy {
    return fileListingSource.orderBy;
  }

  @computed
  OrderDir get orderDir {
    return fileListingSource.orderDir;
  }

  @computed
  List<String> get gitIgnorePattern {
    return fileListingSource.gitIgnorePattern;
  }

  /// [source] of the last item in [fileListingSourceStack]
  @computed
  FileExplorerSource get source {
    return fileListingSource.source;
  }

  /// returns [true] if meta+a is pressed in the keyboard
  @computed
  bool get isSelectAllPressed {
    final deepEq = const DeepCollectionEquality().equals;

    return deepEq(activeKeyboardModifierIntent?.keys ?? [], [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyA,
    ]);
  }

  /// Adding a new [FileExplorerSource] will first add the request to the [fileListingSourceStack]
  /// and then fetch files from the respective source
  @action
  Future<void> navigateToSource({
    @required String fullPath,
    @required FileExplorerSource source,

    /// clearing stack will empty [fileListingSourceStack] first and then insert a new request
    @required bool clearStack,

    /// the full path to the archive file
    String currentArchiveFilepath,
    OrderBy orderBy,
    OrderDir orderDir,
    String password,
    List<String> gitIgnorePattern,
  }) async {
    assert(fullPath != null);
    assert(source != null);
    assert(clearStack != null);

    if (source == FileExplorerSource.ARCHIVE &&
        currentArchiveFilepath == null) {
      throw "'currentArchiveFilepath' cannot be null if source is 'Archive'";
    }

    // todo: check if archive encrypted before opening
    // todo:    if is encrypted error received then show the popup for password
    // todo:    if password invalid error received then show the popup for password with validation error text
    // todo:    write test cases for the same

    // todo add toggle hidden files
    final _request = FileListingRequest(
      path: fullPath,
      archiveFilepath: currentArchiveFilepath,
      gitIgnorePattern: gitIgnorePattern,
      orderDir: orderDir,
      orderBy: orderBy,
      password: password,
      source: source,
    );

    if (clearStack) {
      final _fileListingSourceStackTemp = fileListingSourceStack;
      _fileListingSourceStackTemp.clear();

      fileListingSourceStack = _fileListingSourceStackTemp;
    }

    _addToFileListingRequestStack(_request);

    return _fetchFiles(
      popStackOnError: source == FileExplorerSource.ARCHIVE,
      invalidateCache: true,
    );
  }

  @action
  Future<void> refreshFiles({bool invalidateCache}) async {
    return _fetchFiles(invalidateCache: invalidateCache);
  }

  /// update the last item in the stack
  @action
  Future<void> _updateFileListingRequest(FileListingRequest request) async {
    final _fileListingSourceStackTemp = fileListingSourceStack;
    _fileListingSourceStackTemp.last = request;

    fileListingSourceStack = _fileListingSourceStackTemp;

    return refreshFiles();
  }

  /// set the current path
  @action
  Future<void> setCurrentPath(String value) async {
    assert(value != null);

    return _updateFileListingRequest(
      fileListingSource.copyWith(path: value),
    );
  }

  /// set [orderDir] and [orderBy]
  @action
  Future<void> setOrderDirOrderBy({
    @required OrderDir orderDir,
    @required OrderBy orderBy,
  }) async {
    return _updateFileListingRequest(
      fileListingSource.copyWith(
        orderDir: orderDir ?? this.orderDir,
        orderBy: orderBy ?? this.orderBy,
      ),
    );
  }

  /// navigate to the previous directory
  @action
  Future<void> gotoPrevDirectory() async {
    final _parentPath = getParentPath(currentPath);

    /// if the [currentPath] is the root path then pop the [_fileListingRequestStack]
    /// this will navigate the user back to the previous source in the [_fileListingRequestStack]
    if (currentPath == _parentPath) {
      /// make sure that there always atleast one stack available in the stack
      return _popFileListingSourceStack();
    }

    // update the last item in the stack
    return _updateFileListingRequest(
      fileListingSource.copyWith(path: _parentPath),
    );
  }

  @action
  Future<void> _popFileListingSourceStack() async {
    if (fileListingSourceStack.length > 1) {
      final _fileListingSourceStackTemp = fileListingSourceStack;
      _fileListingSourceStackTemp.removeLast();

      fileListingSourceStack = _fileListingSourceStackTemp;

      return refreshFiles(invalidateCache: true);
    }
  }

  @action
  Future<void> _fetchFiles({
    bool invalidateCache,
    bool popStackOnError,
  }) async {
    final c = Completer();

    final _popStackOnError = popStackOnError ?? false;
    fileContainersException = null;

    /// reset the selected files on directory/path/refresh
    resetSelectedFiles();

    fileContainersFuture = ObservableFuture(
      _fileExplorerController.listFiles(
        request: fileListingSource,
        invalidateCache: invalidateCache,
      ),
    );

    final _data = await fileContainersFuture;

    _data.pick(
      onError: (error) async {
        fileContainersException = error;

        /// if in an exception occured then remove the last request
        /// from the [fileListingSource] stack
        if (_popStackOnError) {
          await _popFileListingSourceStack();
        }

        c.complete();
      },
      onData: (data) {
        fileContainers = data;
        fileContainersException = null;

        c.complete();
      },
      onNoData: () {
        fileContainers = [];
        fileContainersException = null;

        c.complete();
      },
    );

    return c.future;
  }

  @action
  void _setFileListingRequestStack(FileListingRequest param) {
    fileListingSourceStack = [param];
  }

  @action
  void _addToFileListingRequestStack(FileListingRequest param) {
    if (isNullOrEmpty(fileListingSourceStack)) {
      _setFileListingRequestStack(param);

      return;
    }

    final _fileListingSourceStackTemp = fileListingSourceStack;
    _fileListingSourceStackTemp.add(param);

    fileListingSourceStack = _fileListingSourceStackTemp;
  }

  /// set files in the explorer window
  /// if [appendToList] is false then only one file will be selected
  /// if [appendToList] is true then multiple file selection is allowed
  /// todo write tests
  @action
  void setSelectedFile(
    FileListingResponse fileContainer, {
    bool appendToList = false,
  }) {
    assert(fileContainer != null);
    assert(appendToList != null);

    final _uniqueId = fileContainer.uniqueId;

    var _selectedFiles = selectedFiles;

    /// if [appendToList] is true then multiple file selection is allowed
    if (appendToList) {
      /// if [selectedFiles] list contains the incoming file then remove it
      if (isNotNull(_selectedFiles[_uniqueId])) {
        _selectedFiles.remove(_uniqueId);
      } else {
        /// if [selectedFiles] list does not contain the incoming file then add it
        _selectedFiles.putIfAbsent(_uniqueId, () => fileContainer);
      }
    } else {
      /// if [appendToList] is false then only one file will be selected
      _selectedFiles = {_uniqueId: fileContainer};
    }

    selectedFiles = _selectedFiles;
  }

  /// select all files in the explorer window
  ///   /// todo write tests
  @action
  void selectAllFiles() {
    final _filesMap = {
      for (var fileContainer in fileContainers)
        fileContainer.uniqueId: fileContainer
    };

    selectedFiles = {..._filesMap};
  }

  /// reselect selected files in the explorer window
  ///   /// todo write tests
  @action
  void resetSelectedFiles() {
    selectedFiles = ObservableMap();
  }

  /// todo write tests
  @action
  void setActiveKeyboardModifierIntent(KeyboardModifierIntent intent) {
    activeKeyboardModifierIntent = intent;
  }

  /// todo write tests
  @action
  void resetActiveKeyboardModifierIntent() {
    activeKeyboardModifierIntent = null;
  }
}
