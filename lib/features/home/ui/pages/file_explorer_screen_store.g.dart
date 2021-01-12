// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_explorer_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileExplorerScreenStore on _FileExplorerScreenStoreBase, Store {
  Computed<bool> _$fileListingInProgressComputed;

  @override
  bool get fileListingInProgress => (_$fileListingInProgressComputed ??=
          Computed<bool>(() => super.fileListingInProgress,
              name: '_FileExplorerScreenStoreBase.fileListingInProgress'))
      .value;

  final _$fileListAtom = Atom(name: '_FileExplorerScreenStoreBase.fileList');

  @override
  List<FileListingResponse> get fileList {
    _$fileListAtom.reportRead();
    return super.fileList;
  }

  @override
  set fileList(List<FileListingResponse> value) {
    _$fileListAtom.reportWrite(value, super.fileList, () {
      super.fileList = value;
    });
  }

  final _$fileListFutureAtom =
      Atom(name: '_FileExplorerScreenStoreBase.fileListFuture');

  @override
  ObservableFuture<DC<Exception, List<FileListingResponse>>>
      get fileListFuture {
    _$fileListFutureAtom.reportRead();
    return super.fileListFuture;
  }

  @override
  set fileListFuture(
      ObservableFuture<DC<Exception, List<FileListingResponse>>> value) {
    _$fileListFutureAtom.reportWrite(value, super.fileListFuture, () {
      super.fileListFuture = value;
    });
  }

  final _$fileListExceptionAtom =
      Atom(name: '_FileExplorerScreenStoreBase.fileListException');

  @override
  Exception get fileListException {
    _$fileListExceptionAtom.reportRead();
    return super.fileListException;
  }

  @override
  set fileListException(Exception value) {
    _$fileListExceptionAtom.reportWrite(value, super.fileListException, () {
      super.fileListException = value;
    });
  }

  final _$_fileListingSourceStackAtom =
      Atom(name: '_FileExplorerScreenStoreBase._fileListingSourceStack');

  @override
  List<FileListingRequest> get _fileListingSourceStack {
    _$_fileListingSourceStackAtom.reportRead();
    return super._fileListingSourceStack;
  }

  @override
  set _fileListingSourceStack(List<FileListingRequest> value) {
    _$_fileListingSourceStackAtom
        .reportWrite(value, super._fileListingSourceStack, () {
      super._fileListingSourceStack = value;
    });
  }

  final _$navigateToSourceAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.navigateToSource');

  @override
  Future<void> navigateToSource(
      {@required String fullPath,
      @required FileExplorerSource source,
      @required bool clearStack,
      String currentArchiveFilepath,
      OrderBy orderBy,
      OrderDir orderDir,
      String password,
      List<String> gitIgnorePattern}) {
    return _$navigateToSourceAsyncAction.run(() => super.navigateToSource(
        fullPath: fullPath,
        source: source,
        clearStack: clearStack,
        currentArchiveFilepath: currentArchiveFilepath,
        orderBy: orderBy,
        orderDir: orderDir,
        password: password,
        gitIgnorePattern: gitIgnorePattern));
  }

  final _$refreshFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.refreshFiles');

  @override
  Future<void> refreshFiles({bool invalidateCache}) {
    return _$refreshFilesAsyncAction
        .run(() => super.refreshFiles(invalidateCache: invalidateCache));
  }

  final _$_updateFileListingRequestAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase._updateFileListingRequest');

  @override
  Future<void> _updateFileListingRequest(FileListingRequest request) {
    return _$_updateFileListingRequestAsyncAction
        .run(() => super._updateFileListingRequest(request));
  }

  final _$setCurrentPathAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.setCurrentPath');

  @override
  Future<void> setCurrentPath(String value) {
    return _$setCurrentPathAsyncAction.run(() => super.setCurrentPath(value));
  }

  final _$setOrderDirOrderByAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.setOrderDirOrderBy');

  @override
  Future<void> setOrderDirOrderBy(
      {@required OrderDir orderDir, @required OrderBy orderBy}) {
    return _$setOrderDirOrderByAsyncAction.run(
        () => super.setOrderDirOrderBy(orderDir: orderDir, orderBy: orderBy));
  }

  final _$gotoPrevDirectoryAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.gotoPrevDirectory');

  @override
  Future<void> gotoPrevDirectory() {
    return _$gotoPrevDirectoryAsyncAction.run(() => super.gotoPrevDirectory());
  }

  final _$popFileListingRequestStackAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.popFileListingRequestStack');

  @override
  Future<void> popFileListingRequestStack() {
    return _$popFileListingRequestStackAsyncAction
        .run(() => super.popFileListingRequestStack());
  }

  final _$_fetchFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase._fetchFiles');

  @override
  Future<void> _fetchFiles({bool invalidateCache, bool popStackOnError}) {
    return _$_fetchFilesAsyncAction.run(() => super._fetchFiles(
        invalidateCache: invalidateCache, popStackOnError: popStackOnError));
  }

  final _$_FileExplorerScreenStoreBaseActionController =
      ActionController(name: '_FileExplorerScreenStoreBase');

  @override
  void _setFileListingRequestStack(FileListingRequest param) {
    final _$actionInfo =
        _$_FileExplorerScreenStoreBaseActionController.startAction(
            name: '_FileExplorerScreenStoreBase._setFileListingRequestStack');
    try {
      return super._setFileListingRequestStack(param);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _addToFileListingRequestStack(FileListingRequest param) {
    final _$actionInfo =
        _$_FileExplorerScreenStoreBaseActionController.startAction(
            name: '_FileExplorerScreenStoreBase._addToFileListingRequestStack');
    try {
      return super._addToFileListingRequestStack(param);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fileList: ${fileList},
fileListFuture: ${fileListFuture},
fileListException: ${fileListException},
fileListingInProgress: ${fileListingInProgress}
    ''';
  }
}
