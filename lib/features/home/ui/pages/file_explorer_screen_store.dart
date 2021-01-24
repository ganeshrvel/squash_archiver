import 'dart:async';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:data_channel/data_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/features/home/data/controllers/file_explorer_controller.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_response.dart';
import 'package:squash_archiver/features/home/data/models/password_request.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';

part 'file_explorer_screen_store.g.dart';

class FileExplorerScreenStore = _FileExplorerScreenStoreBase
    with _$FileExplorerScreenStore;

abstract class _FileExplorerScreenStoreBase with Store {
  final _fileExplorerController = getIt<FileExplorerController>();

  /// [FileListingResponse] object stack
  @observable
  List<FileListingResponse> fileContainers =
      ObservableList<FileListingResponse>();

  @observable
  ObservableFuture<DC<Exception, List<FileListingResponse>>>
      fileContainersFuture = ObservableFuture(Future.value());

  /// [Exception] from [_fetchFiles]
  @observable
  Exception fileContainersException;

  /// [FileListingRequest] object stack
  @observable
  @visibleForTesting
  List<FileListingRequest> fileListingSourceStack = ObservableList();

  /// if passwordOverlay is NOT null then show the password request overlay
  @observable
  PasswordRequest requestPassword;

  /// the selected files in the file explorer
  /// ///todo make selectedFiles a map instead of list inorder to make it o(1)
  @observable
  Map<String, FileListingResponse> selectedFiles =
      ObservableMap<String, FileListingResponse>();

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

  /// Adding a new [FileExplorerSource] will first add the request to the [fileListingSourceStack]
  /// and then fetch files from the respective source
  @action
  Future<void> navigateToSource({
    /// full path to the next directory
    /// for [FileExplorerSource.local] fullPath is the path to the next directory
    /// for [FileExplorerSource.archive] fullPath is the directory path within the archive
    @required String fullPath,

    /// the full path to the archive file
    String currentArchiveFilepath,

    /// source type [FileExplorerSource.local] or [FileExplorerSource.archive]
    @required FileExplorerSource source,

    /// clearing stack will empty [fileListingSourceStack] first and then insert a new request
    @required bool clearStack,

    /// sort the files by name, size or modified time. order by 'fullPath' isn't supported yet.
    OrderBy orderBy,

    /// sort the files in ascending or descending order. orderDir 'none' isn't supported yet.
    OrderDir orderDir,

    /// password field. If null or empty then password will be ignored.
    String password,

    /// gitignore pattern list
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

  /// pop the last source item ([FileListingRequest] object) from the [fileListingSourceStack] stack
  @action
  Future<void> _popFileListingSourceStack() async {
    if (fileListingSourceStack.length > 1) {
      final _fileListingSourceStackTemp = fileListingSourceStack;
      _fileListingSourceStackTemp.removeLast();

      fileListingSourceStack = _fileListingSourceStackTemp;

      return refreshFiles(invalidateCache: true);
    }
  }

  ///  fetch files from local or archive data source
  @action
  Future<void> _fetchFiles({
    /// InvalidateCache is only using for listing archive files.
    /// Use 'invalidate' flag to use the cache while listing archive files.
    /// If [invalidateCache] is set as true while listing the archive files
    /// then the files will be fetched again from the [archiver_ffi]
    /// Reading an archive file requires a few seconds as there are multiple
    /// file processing involved.
    /// Use this as required and only when neccessary
    bool invalidateCache,

    /// should pop the [fileListingSourceStack] stack on error.
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
        /// set [requestPassword] if the [error] is [PasswordRequiredException]
        if (error is PasswordRequiredException) {
          setRequestPassword(
            PasswordRequest(
              fileListingRequest: fileListingSource,
              invalidPassword: false,
            ),
          );
        }

        /// mark [requestPassword.invalidPassword] as true if the [error] is [InvalidPasswordException]
        else if (error is InvalidPasswordException) {
          setRequestPassword(
            PasswordRequest(
              fileListingRequest: fileListingSource,
              invalidPassword: true,
            ),
          );
        }

        /// set [fileContainersException] for all other errors
        else {
          fileContainersException = error;
        }

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
        fileContainers = ObservableList();
        fileContainersException = null;

        c.complete();
      },
    );

    return c.future;
  }

  /// set the [fileListingSourceStack]
  @action
  void _setFileListingRequestStack(FileListingRequest value) {
    fileListingSourceStack = [value];
  }

  /// add an item to the [fileListingSourceStack]
  @action
  void _addToFileListingRequestStack(FileListingRequest value) {
    /// if [fileListingSourceStack] is empty then SET a new [FileListingRequest] object to it
    if (isNullOrEmpty(fileListingSourceStack)) {
      _setFileListingRequestStack(value);

      return;
    }

    /// if [fileListingSourceStack] is NOT empty then ADD a new [FileListingRequest] object to it
    final _fileListingSourceStackTemp = fileListingSourceStack;
    _fileListingSourceStackTemp.add(value);

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

  /// set the password request field
  @action
  void setRequestPassword(PasswordRequest value) {
    requestPassword = value;
  }

  /// reset the password request field
  @action
  void resetRequestPassword() {
    requestPassword = null;
  }
}
