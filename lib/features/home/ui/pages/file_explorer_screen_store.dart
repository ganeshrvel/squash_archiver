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
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';

part 'file_explorer_screen_store.g.dart';

class FileExplorerScreenStore = _FileExplorerScreenStoreBase
    with _$FileExplorerScreenStore;

abstract class _FileExplorerScreenStoreBase with Store {
  final _fileExplorerController = getIt<FileExplorerController>();

  @observable
  List<FileListingResponse> fileList = ObservableList<FileListingResponse>();

  @observable
  ObservableFuture<DC<Exception, List<FileListingResponse>>> fileListFuture =
      ObservableFuture(Future.value());

  @observable
  Exception fileListException;

  @observable
  @visibleForTesting
  List<FileListingRequest> fileListingSourceStack = ObservableList();

  FileListingRequest get _fileListingSource {
    if (isNullOrEmpty(fileListingSourceStack)) {
      return FileListingRequest(path: '');
    }

    return fileListingSourceStack.last;
  }

  @computed
  bool get fileListingInProgress {
    return isStateLoading(fileListFuture);
  }

  /// current path in the file explorer; path of the last item in [fileListingSourceStack]
  String get currentPath {
    return _fileListingSource.path;
  }

  /// full path to the currently opened archive file in the file explorer; [archiveFilepath] of the last item in [fileListingSourceStack]
  String get currentArchiveFilepath {
    return _fileListingSource.archiveFilepath;
  }

  /// password of the currently opened file in the file explorer (if any); [password] of the last item in [fileListingSourceStack]
  String get password {
    return _fileListingSource.password;
  }

  OrderBy get orderBy {
    return _fileListingSource.orderBy;
  }

  OrderDir get orderDir {
    return _fileListingSource.orderDir;
  }

  List<String> get gitIgnorePattern {
    return _fileListingSource.gitIgnorePattern;
  }

  /// [source] of the last item in [fileListingSourceStack]
  FileExplorerSource get source {
    return _fileListingSource.source;
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
      fileListingSourceStack.clear();
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
    fileListingSourceStack.last = request;

    return refreshFiles();
  }

  /// set the current path
  @action
  Future<void> setCurrentPath(String value) async {
    assert(value != null);

    return _updateFileListingRequest(
      _fileListingSource.copyWith(path: value),
    );
  }

  /// set [orderDir] and [orderBy]
  @action
  Future<void> setOrderDirOrderBy({
    @required OrderDir orderDir,
    @required OrderBy orderBy,
  }) async {
    return _updateFileListingRequest(
      _fileListingSource.copyWith(
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
      return popFileListingRequestStack();
    }

    // update the last item in the stack
    return _updateFileListingRequest(
      _fileListingSource.copyWith(path: _parentPath),
    );
  }

  @action
  Future<void> popFileListingRequestStack() async {
    if (fileListingSourceStack.length > 1) {
      fileListingSourceStack.removeLast();

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
    fileListException = null;

    fileListFuture = ObservableFuture(
      _fileExplorerController.listFiles(
        request: _fileListingSource,
        invalidateCache: invalidateCache,
      ),
    );

    final _data = await fileListFuture;

    _data.pick(
      onError: (error) async {
        fileListException = error;

        if (_popStackOnError) {
          await popFileListingRequestStack();
        }

        c.complete();
      },
      onData: (data) {
        fileList = data;
        fileListException = null;

        c.complete();
      },
      onNoData: () {
        fileList = [];
        fileListException = null;

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

    fileListingSourceStack.add(param);
  }
}
