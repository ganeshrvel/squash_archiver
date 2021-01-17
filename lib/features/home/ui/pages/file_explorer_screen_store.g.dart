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

  final _$filesAtom = Atom(name: '_FileExplorerScreenStoreBase.files');

  @override
  List<FileListingResponse> get files {
    _$filesAtom.reportRead();
    return super.files;
  }

  @override
  set files(List<FileListingResponse> value) {
    _$filesAtom.reportWrite(value, super.files, () {
      super.files = value;
    });
  }

  final _$filesFutureAtom =
      Atom(name: '_FileExplorerScreenStoreBase.filesFuture');

  @override
  ObservableFuture<DC<Exception, List<FileListingResponse>>> get filesFuture {
    _$filesFutureAtom.reportRead();
    return super.filesFuture;
  }

  @override
  set filesFuture(
      ObservableFuture<DC<Exception, List<FileListingResponse>>> value) {
    _$filesFutureAtom.reportWrite(value, super.filesFuture, () {
      super.filesFuture = value;
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

  final _$fileListingSourceStackAtom =
      Atom(name: '_FileExplorerScreenStoreBase.fileListingSourceStack');

  @override
  List<FileListingRequest> get fileListingSourceStack {
    _$fileListingSourceStackAtom.reportRead();
    return super.fileListingSourceStack;
  }

  @override
  set fileListingSourceStack(List<FileListingRequest> value) {
    _$fileListingSourceStackAtom
        .reportWrite(value, super.fileListingSourceStack, () {
      super.fileListingSourceStack = value;
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

  final _$_popFileListingSourceStackAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase._popFileListingSourceStack');

  @override
  Future<void> _popFileListingSourceStack() {
    return _$_popFileListingSourceStackAsyncAction
        .run(() => super._popFileListingSourceStack());
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
files: ${files},
filesFuture: ${filesFuture},
fileListException: ${fileListException},
fileListingSourceStack: ${fileListingSourceStack},
fileListingInProgress: ${fileListingInProgress}
    ''';
  }
}
