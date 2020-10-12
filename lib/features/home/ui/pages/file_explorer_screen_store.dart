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
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';

part 'file_explorer_screen_store.g.dart';

class FileExplorerScreenStore = _FileExplorerScreenStoreBase
    with _$FileExplorerScreenStore;

abstract class _FileExplorerScreenStoreBase with Store {
  final _fileExplorerController = getIt<FileExplorerController>();

  @observable
  List<FileInfo> fileList = ObservableList<FileInfo>();

  @observable
  ObservableFuture<DC<Exception, List<FileInfo>>> fileListFuture =
      ObservableFuture(Future.value());

  @observable
  Exception fileListException;

  @observable
  List<FileListingRequest> _fileListingRequestStack = ObservableList();

  FileListingRequest get _fileListingRequest {
    if (isNullOrEmpty(_fileListingRequestStack)) {
      return FileListingRequest(path: '');
    }

    return _fileListingRequestStack.last;
  }

  @computed
  bool get fileListingInProgress {
    return isStateLoading(fileListFuture);
  }

  String get currentPath {
    return _fileListingRequest.path;
  }

  String get currentArchiveFilename {
    return _fileListingRequest.archiveFilename;
  }

  String get password {
    return _fileListingRequest.password;
  }

  OrderBy get orderBy {
    return _fileListingRequest.orderBy;
  }

  OrderDir get orderDir {
    return _fileListingRequest.orderDir;
  }

  List<String> get gitIgnorePattern {
    return _fileListingRequest.gitIgnorePattern;
  }

  FileExplorerSource get source {
    return _fileListingRequest.source;
  }

  /// Adding a new [FileExplorerSource] will first add the request to the [_fileListingRequestStack]
  /// and then fetch files from the respective source
  @action
  Future<void> newSource({
    @required String fullPath,
    @required FileExplorerSource source,

    /// clearing stack will empty the [_fileListingRequestStack] first and then insert a new request
    @required bool clearStack,
    String currentArchiveFilename,
    OrderBy orderBy,
    OrderDir orderDir,
    String password,
    List<String> gitIgnorePattern,
  }) async {
    assert(fullPath != null);
    assert(source != null);
    assert(clearStack != null);

    if (source == FileExplorerSource.ARCHIVE &&
        currentArchiveFilename == null) {
      throw "'currentArchiveFilename' cannot be null if source is 'Archive'";
    }

    // todo check is encrypted archive before opening
    // todo add toggle hidden files
    final _request = FileListingRequest(
      path: fullPath,
      archiveFilename: currentArchiveFilename,
      gitIgnorePattern: gitIgnorePattern,
      orderDir: orderDir,
      orderBy: orderBy,
      password: password,
      source: source,
    );

    if (clearStack) {
      _fileListingRequestStack.clear();
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
    _fileListingRequestStack.last = request;

    return refreshFiles();
  }

  /// set the current path
  @action
  Future<void> setCurrentPath(String value) async {
    assert(value != null);

    return _updateFileListingRequest(
      _fileListingRequest.copyWith(path: value),
    );
  }

  /// set [orderDir] and [orderBy]
  @action
  Future<void> setOrderDirOrderBy({
    @required OrderDir orderDir,
    @required OrderBy orderBy,
  }) async {
    /// todo dont invalidate the cache for archive [orderDir] and [orderBy] sorting

    return _updateFileListingRequest(
      _fileListingRequest.copyWith(
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
      _fileListingRequest.copyWith(path: _parentPath),
    );
  }

  @action
  Future<void> popFileListingRequestStack() async {
    if (_fileListingRequestStack.length > 1) {
      _fileListingRequestStack.removeLast();

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
        request: _fileListingRequest,
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
    _fileListingRequestStack = [param];
  }

  @action
  void _addToFileListingRequestStack(FileListingRequest param) {
    if (isNullOrEmpty(_fileListingRequestStack)) {
      _setFileListingRequestStack(param);

      return;
    }

    _fileListingRequestStack.add(param);
  }
}
