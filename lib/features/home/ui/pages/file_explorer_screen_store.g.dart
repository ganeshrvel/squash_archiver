// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_explorer_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileExplorerScreenStore on _FileExplorerScreenStoreBase, Store {
  Computed<FileListingRequest>? _$fileListingSourceComputed;

  @override
  FileListingRequest get fileListingSource => (_$fileListingSourceComputed ??=
          Computed<FileListingRequest>(() => super.fileListingSource,
              name: '_FileExplorerScreenStoreBase.fileListingSource'))
      .value;
  Computed<bool>? _$fileListingInProgressComputed;

  @override
  bool get fileListingInProgress => (_$fileListingInProgressComputed ??=
          Computed<bool>(() => super.fileListingInProgress,
              name: '_FileExplorerScreenStoreBase.fileListingInProgress'))
      .value;
  Computed<bool>? _$archiveLoadingInProgressComputed;

  @override
  bool get archiveLoadingInProgress => (_$archiveLoadingInProgressComputed ??=
          Computed<bool>(() => super.archiveLoadingInProgress,
              name: '_FileExplorerScreenStoreBase.archiveLoadingInProgress'))
      .value;
  Computed<String>? _$currentPathComputed;

  @override
  String get currentPath =>
      (_$currentPathComputed ??= Computed<String>(() => super.currentPath,
              name: '_FileExplorerScreenStoreBase.currentPath'))
          .value;
  Computed<String?>? _$currentArchiveFilepathComputed;

  @override
  String? get currentArchiveFilepath => (_$currentArchiveFilepathComputed ??=
          Computed<String?>(() => super.currentArchiveFilepath,
              name: '_FileExplorerScreenStoreBase.currentArchiveFilepath'))
      .value;
  Computed<String?>? _$passwordComputed;

  @override
  String? get password =>
      (_$passwordComputed ??= Computed<String?>(() => super.password,
              name: '_FileExplorerScreenStoreBase.password'))
          .value;
  Computed<OrderBy?>? _$orderByComputed;

  @override
  OrderBy? get orderBy =>
      (_$orderByComputed ??= Computed<OrderBy?>(() => super.orderBy,
              name: '_FileExplorerScreenStoreBase.orderBy'))
          .value;
  Computed<OrderDir?>? _$orderDirComputed;

  @override
  OrderDir? get orderDir =>
      (_$orderDirComputed ??= Computed<OrderDir?>(() => super.orderDir,
              name: '_FileExplorerScreenStoreBase.orderDir'))
          .value;
  Computed<List<String>?>? _$gitIgnorePatternComputed;

  @override
  List<String>? get gitIgnorePattern => (_$gitIgnorePatternComputed ??=
          Computed<List<String>?>(() => super.gitIgnorePattern,
              name: '_FileExplorerScreenStoreBase.gitIgnorePattern'))
      .value;
  Computed<FileExplorerSource?>? _$sourceComputed;

  @override
  FileExplorerSource? get source =>
      (_$sourceComputed ??= Computed<FileExplorerSource?>(() => super.source,
              name: '_FileExplorerScreenStoreBase.source'))
          .value;

  final _$fileContainersAtom =
      Atom(name: '_FileExplorerScreenStoreBase.fileContainers');

  @override
  List<FileListingResponse> get fileContainers {
    _$fileContainersAtom.reportRead();
    return super.fileContainers;
  }

  @override
  set fileContainers(List<FileListingResponse> value) {
    _$fileContainersAtom.reportWrite(value, super.fileContainers, () {
      super.fileContainers = value;
    });
  }

  final _$fileContainersFutureAtom =
      Atom(name: '_FileExplorerScreenStoreBase.fileContainersFuture');

  @override
  ObservableFuture<DC<Exception, List<FileListingResponse>>>?
      get fileContainersFuture {
    _$fileContainersFutureAtom.reportRead();
    return super.fileContainersFuture;
  }

  @override
  set fileContainersFuture(
      ObservableFuture<DC<Exception, List<FileListingResponse>>>? value) {
    _$fileContainersFutureAtom.reportWrite(value, super.fileContainersFuture,
        () {
      super.fileContainersFuture = value;
    });
  }

  final _$fileContainersExceptionAtom =
      Atom(name: '_FileExplorerScreenStoreBase.fileContainersException');

  @override
  Exception? get fileContainersException {
    _$fileContainersExceptionAtom.reportRead();
    return super.fileContainersException;
  }

  @override
  set fileContainersException(Exception? value) {
    _$fileContainersExceptionAtom
        .reportWrite(value, super.fileContainersException, () {
      super.fileContainersException = value;
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

  final _$requestPasswordAtom =
      Atom(name: '_FileExplorerScreenStoreBase.requestPassword');

  @override
  PasswordRequest? get requestPassword {
    _$requestPasswordAtom.reportRead();
    return super.requestPassword;
  }

  @override
  set requestPassword(PasswordRequest? value) {
    _$requestPasswordAtom.reportWrite(value, super.requestPassword, () {
      super.requestPassword = value;
    });
  }

  final _$selectedFilesAtom =
      Atom(name: '_FileExplorerScreenStoreBase.selectedFiles');

  @override
  Map<String, FileListingResponse> get selectedFiles {
    _$selectedFilesAtom.reportRead();
    return super.selectedFiles;
  }

  @override
  set selectedFiles(Map<String, FileListingResponse> value) {
    _$selectedFilesAtom.reportWrite(value, super.selectedFiles, () {
      super.selectedFiles = value;
    });
  }

  final _$navigateToSourceAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.navigateToSource');

  @override
  Future<void> navigateToSource(
      {required String fullPath,
      String? currentArchiveFilepath,
      required FileExplorerSource source,
      required bool clearStack,
      OrderBy? orderBy,
      OrderDir? orderDir,
      String? password,
      List<String>? gitIgnorePattern}) {
    return _$navigateToSourceAsyncAction.run(() => super.navigateToSource(
        fullPath: fullPath,
        currentArchiveFilepath: currentArchiveFilepath,
        source: source,
        clearStack: clearStack,
        orderBy: orderBy,
        orderDir: orderDir,
        password: password,
        gitIgnorePattern: gitIgnorePattern));
  }

  final _$refreshFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase.refreshFiles');

  @override
  Future<void> refreshFiles({bool invalidateCache = false}) {
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
      {required OrderDir? orderDir, required OrderBy? orderBy}) {
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
  Future<void> _fetchFiles(
      {bool invalidateCache = false, bool? popStackOnError}) {
    return _$_fetchFilesAsyncAction.run(() => super._fetchFiles(
        invalidateCache: invalidateCache, popStackOnError: popStackOnError));
  }

  final _$_FileExplorerScreenStoreBaseActionController =
      ActionController(name: '_FileExplorerScreenStoreBase');

  @override
  void _setFileListingRequestStack(FileListingRequest value) {
    final _$actionInfo =
        _$_FileExplorerScreenStoreBaseActionController.startAction(
            name: '_FileExplorerScreenStoreBase._setFileListingRequestStack');
    try {
      return super._setFileListingRequestStack(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _addToFileListingRequestStack(FileListingRequest value) {
    final _$actionInfo =
        _$_FileExplorerScreenStoreBaseActionController.startAction(
            name: '_FileExplorerScreenStoreBase._addToFileListingRequestStack');
    try {
      return super._addToFileListingRequestStack(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedFile(FileListingResponse fileContainer,
      {bool appendToList = false}) {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.setSelectedFile');
    try {
      return super.setSelectedFile(fileContainer, appendToList: appendToList);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectAllFiles() {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.selectAllFiles');
    try {
      return super.selectAllFiles();
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetSelectedFiles() {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.resetSelectedFiles');
    try {
      return super.resetSelectedFiles();
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRequestPassword(PasswordRequest value) {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.setRequestPassword');
    try {
      return super.setRequestPassword(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetRequestPassword() {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.resetRequestPassword');
    try {
      return super.resetRequestPassword();
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fileContainers: ${fileContainers},
fileContainersFuture: ${fileContainersFuture},
fileContainersException: ${fileContainersException},
fileListingSourceStack: ${fileListingSourceStack},
requestPassword: ${requestPassword},
selectedFiles: ${selectedFiles},
fileListingSource: ${fileListingSource},
fileListingInProgress: ${fileListingInProgress},
archiveLoadingInProgress: ${archiveLoadingInProgress},
currentPath: ${currentPath},
currentArchiveFilepath: ${currentArchiveFilepath},
password: ${password},
orderBy: ${orderBy},
orderDir: ${orderDir},
gitIgnorePattern: ${gitIgnorePattern},
source: ${source}
    ''';
  }
}
