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
  ArchiverOrderBy get orderBy {
    _$orderByAtom.reportRead();
    return super.orderBy;
  }

  @override
  set orderBy(ArchiverOrderBy value) {
    _$orderByAtom.reportWrite(value, super.orderBy, () {
      super.orderBy = value;
    });
  }

  final _$orderDirAtom = Atom(name: '_FileExplorerScreenStoreBase.orderDir');

  @override
  ArchiverOrderDir get orderDir {
    _$orderDirAtom.reportRead();
    return super.orderDir;
  }

  @override
  set orderDir(ArchiverOrderDir value) {
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
  ObservableFuture<DC<Exception, List<ArchiveFileInfo>>> get fileListFuture {
    _$fileListFutureAtom.reportRead();
    return super.fileListFuture;
  }

  @override
  set fileListFuture(
      ObservableFuture<DC<Exception, List<ArchiveFileInfo>>> value) {
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
  List<ArchiveFileInfo> get fileList {
    _$fileListAtom.reportRead();
    return super.fileList;
  }

  @override
  set fileList(List<ArchiveFileInfo> value) {
    _$fileListAtom.reportWrite(value, super.fileList, () {
      super.fileList = value;
    });
  }

  final _$fetchFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.fetchFiles');

  @override
  Future<void> fetchFiles({bool invalidateCache}) {
    return _$fetchFilesAsyncAction
        .run(() => super.fetchFiles(invalidateCache: invalidateCache));
  }

  final _$refreshFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.refreshFiles');

  @override
  Future<void> refreshFiles({bool invalidateCache}) {
    return _$refreshFilesAsyncAction
        .run(() => super.refreshFiles(invalidateCache: invalidateCache));
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
  void setFiles(List<ArchiveFileInfo> value) {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.setFiles');
    try {
      return super.setFiles(value);
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
