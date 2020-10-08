// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_explorer_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileExplorerScreenStore on _FileExplorerScreenStoreBase, Store {
  Computed<bool> _$listFilesInProgressComputed;

  @override
  bool get listFilesInProgress => (_$listFilesInProgressComputed ??=
          Computed<bool>(() => super.listFilesInProgress,
              name: '_FileExplorerScreenStoreBase.listFilesInProgress'))
      .value;

  final _$fileListAtom = Atom(name: '_FileExplorerScreenStoreBase.fileList');

  @override
  List<FileInfo> get fileList {
    _$fileListAtom.reportRead();
    return super.fileList;
  }

  @override
  set fileList(List<FileInfo> value) {
    _$fileListAtom.reportWrite(value, super.fileList, () {
      super.fileList = value;
    });
  }

  final _$fileListFutureAtom =
      Atom(name: '_FileExplorerScreenStoreBase.fileListFuture');

  @override
  ObservableFuture<DC<Exception, List<FileInfo>>> get fileListFuture {
    _$fileListFutureAtom.reportRead();
    return super.fileListFuture;
  }

  @override
  set fileListFuture(ObservableFuture<DC<Exception, List<FileInfo>>> value) {
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

  final _$_fileListingRequestStackAtom =
      Atom(name: '_FileExplorerScreenStoreBase._fileListingRequestStack');

  @override
  List<FileListingRequest> get _fileListingRequestStack {
    _$_fileListingRequestStackAtom.reportRead();
    return super._fileListingRequestStack;
  }

  @override
  set _fileListingRequestStack(List<FileListingRequest> value) {
    _$_fileListingRequestStackAtom
        .reportWrite(value, super._fileListingRequestStack, () {
      super._fileListingRequestStack = value;
    });
  }

  final _$newSourceAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.newSource');

  @override
  Future<void> newSource(
      {@required String fullPath,
      @required FileExplorerSource source,
      @required bool clearStack,
      String currentArchiveFilename,
      OrderBy orderBy,
      OrderDir orderDir,
      String password,
      List<String> gitIgnorePattern}) {
    return _$newSourceAsyncAction.run(() => super.newSource(
        fullPath: fullPath,
        source: source,
        clearStack: clearStack,
        currentArchiveFilename: currentArchiveFilename,
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

  final _$gotoPrevDirectoryAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.gotoPrevDirectory');

  @override
  Future<void> gotoPrevDirectory() {
    return _$gotoPrevDirectoryAsyncAction.run(() => super.gotoPrevDirectory());
  }

  final _$_fetchFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase._fetchFiles');

  @override
  Future<void> _fetchFiles({bool invalidateCache}) {
    return _$_fetchFilesAsyncAction
        .run(() => super._fetchFiles(invalidateCache: invalidateCache));
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
listFilesInProgress: ${listFilesInProgress}
    ''';
  }
}
