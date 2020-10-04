// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_explorer_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileExplorerScreenStore on _FileExplorerScreenStoreBase, Store {
  Computed<FileListingRequest> _$_fileListingRequestComputed;

  @override
  FileListingRequest get _fileListingRequest =>
      (_$_fileListingRequestComputed ??= Computed<FileListingRequest>(
              () => super._fileListingRequest,
              name: '_FileExplorerScreenStoreBase._fileListingRequest'))
          .value;
  Computed<bool> _$listFilesInProgressComputed;

  @override
  bool get listFilesInProgress => (_$listFilesInProgressComputed ??=
          Computed<bool>(() => super.listFilesInProgress,
              name: '_FileExplorerScreenStoreBase.listFilesInProgress'))
      .value;

  final _$_fileListingRequestBucketAtom =
      Atom(name: '_FileExplorerScreenStoreBase._fileListingRequestBucket');

  @override
  List<FileListingRequest> get _fileListingRequestBucket {
    _$_fileListingRequestBucketAtom.reportRead();
    return super._fileListingRequestBucket;
  }

  @override
  set _fileListingRequestBucket(List<FileListingRequest> value) {
    _$_fileListingRequestBucketAtom
        .reportWrite(value, super._fileListingRequestBucket, () {
      super._fileListingRequestBucket = value;
    });
  }

  final _$currentPathAtom =
      Atom(name: '_FileExplorerScreenStoreBase.currentPath');

  @override
  String get currentPath {
    _$currentPathAtom.reportRead();
    return super.currentPath;
  }

  @override
  set currentPath(String value) {
    _$currentPathAtom.reportWrite(value, super.currentPath, () {
      super.currentPath = value;
    });
  }

  final _$currentArchiveFilenameAtom =
      Atom(name: '_FileExplorerScreenStoreBase.currentArchiveFilename');

  @override
  String get currentArchiveFilename {
    _$currentArchiveFilenameAtom.reportRead();
    return super.currentArchiveFilename;
  }

  @override
  set currentArchiveFilename(String value) {
    _$currentArchiveFilenameAtom
        .reportWrite(value, super.currentArchiveFilename, () {
      super.currentArchiveFilename = value;
    });
  }

  final _$passwordAtom = Atom(name: '_FileExplorerScreenStoreBase.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$orderByAtom = Atom(name: '_FileExplorerScreenStoreBase.orderBy');

  @override
  OrderBy get orderBy {
    _$orderByAtom.reportRead();
    return super.orderBy;
  }

  @override
  set orderBy(OrderBy value) {
    _$orderByAtom.reportWrite(value, super.orderBy, () {
      super.orderBy = value;
    });
  }

  final _$orderDirAtom = Atom(name: '_FileExplorerScreenStoreBase.orderDir');

  @override
  OrderDir get orderDir {
    _$orderDirAtom.reportRead();
    return super.orderDir;
  }

  @override
  set orderDir(OrderDir value) {
    _$orderDirAtom.reportWrite(value, super.orderDir, () {
      super.orderDir = value;
    });
  }

  final _$gitIgnorePatternAtom =
      Atom(name: '_FileExplorerScreenStoreBase.gitIgnorePattern');

  @override
  List<String> get gitIgnorePattern {
    _$gitIgnorePatternAtom.reportRead();
    return super.gitIgnorePattern;
  }

  @override
  set gitIgnorePattern(List<String> value) {
    _$gitIgnorePatternAtom.reportWrite(value, super.gitIgnorePattern, () {
      super.gitIgnorePattern = value;
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

  final _$_fetchFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase._fetchFiles');

  @override
  Future<void> _fetchFiles({bool invalidateCache}) {
    return _$_fetchFilesAsyncAction
        .run(() => super._fetchFiles(invalidateCache: invalidateCache));
  }

  final _$refreshFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.refreshFiles');

  @override
  Future<void> refreshFiles({bool invalidateCache}) {
    return _$refreshFilesAsyncAction
        .run(() => super.refreshFiles(invalidateCache: invalidateCache));
  }

  final _$fetchFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.fetchFiles');

  @override
  Future<void> fetchFiles(
      {@required FileListingRequest request,
      @required FileExplorerSource source,
      bool invalidateCache}) {
    return _$fetchFilesAsyncAction.run(() => super.fetchFiles(
        request: request, source: source, invalidateCache: invalidateCache));
  }

  final _$newSourceAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.newSource');

  @override
  Future<void> newSource(
      {@required String fullPath, @required FileExplorerSource source}) {
    return _$newSourceAsyncAction
        .run(() => super.newSource(fullPath: fullPath, source: source));
  }

  final _$_FileExplorerScreenStoreBaseActionController =
      ActionController(name: '_FileExplorerScreenStoreBase');

  @override
  void setCurrentPath(String value) {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.setCurrentPath');
    try {
      return super.setCurrentPath(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void gotoPrevDirectory() {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.gotoPrevDirectory');
    try {
      return super.gotoPrevDirectory();
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentArchiveFilename(String value) {
    final _$actionInfo =
        _$_FileExplorerScreenStoreBaseActionController.startAction(
            name: '_FileExplorerScreenStoreBase.setCurrentArchiveFilename');
    try {
      return super.setCurrentArchiveFilename(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFiles(List<FileInfo> value) {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.setFiles');
    try {
      return super.setFiles(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setFileListingRequestBucket(FileListingRequest param) {
    final _$actionInfo =
        _$_FileExplorerScreenStoreBaseActionController.startAction(
            name: '_FileExplorerScreenStoreBase._setFileListingRequestBucket');
    try {
      return super._setFileListingRequestBucket(param);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _addFileListingRequestBucket(FileListingRequest param) {
    final _$actionInfo =
        _$_FileExplorerScreenStoreBaseActionController.startAction(
            name: '_FileExplorerScreenStoreBase._addFileListingRequestBucket');
    try {
      return super._addFileListingRequestBucket(param);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPath: ${currentPath},
currentArchiveFilename: ${currentArchiveFilename},
password: ${password},
orderBy: ${orderBy},
orderDir: ${orderDir},
gitIgnorePattern: ${gitIgnorePattern},
fileListFuture: ${fileListFuture},
fileListException: ${fileListException},
fileList: ${fileList},
listFilesInProgress: ${listFilesInProgress}
    ''';
  }
}
