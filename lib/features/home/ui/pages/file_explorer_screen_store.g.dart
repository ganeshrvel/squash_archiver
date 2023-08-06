// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_explorer_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FileExplorerScreenStore on _FileExplorerScreenStoreBase, Store {
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

  late final _$fileContainersAtom = Atom(
      name: '_FileExplorerScreenStoreBase.fileContainers', context: context);

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

  late final _$fileContainersFutureAtom = Atom(
      name: '_FileExplorerScreenStoreBase.fileContainersFuture',
      context: context);

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

  late final _$fileContainersExceptionAtom = Atom(
      name: '_FileExplorerScreenStoreBase.fileContainersException',
      context: context);

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

  late final _$fileListingSourceStackAtom = Atom(
      name: '_FileExplorerScreenStoreBase.fileListingSourceStack',
      context: context);

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

  late final _$requestPasswordAtom = Atom(
      name: '_FileExplorerScreenStoreBase.requestPassword', context: context);

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

  late final _$selectedFilesAtom = Atom(
      name: '_FileExplorerScreenStoreBase.selectedFiles', context: context);

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

  late final _$fileListingSourceAtom = Atom(
      name: '_FileExplorerScreenStoreBase.fileListingSource', context: context);

  @override
  FileListingRequest get fileListingSource {
    _$fileListingSourceAtom.reportRead();
    return super.fileListingSource;
  }

  @override
  set fileListingSource(FileListingRequest value) {
    _$fileListingSourceAtom.reportWrite(value, super.fileListingSource, () {
      super.fileListingSource = value;
    });
  }

  late final _$navigateToSourceAsyncAction = AsyncAction(
      '_FileExplorerScreenStoreBase.navigateToSource',
      context: context);

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

  late final _$refreshFilesAsyncAction = AsyncAction(
      '_FileExplorerScreenStoreBase.refreshFiles',
      context: context);

  @override
  Future<void> refreshFiles(
      {bool invalidateCache = false, bool clearSelectedFiles = true}) {
    return _$refreshFilesAsyncAction.run(() => super.refreshFiles(
        invalidateCache: invalidateCache,
        clearSelectedFiles: clearSelectedFiles));
  }

  late final _$_updateFileListingRequestAsyncAction = AsyncAction(
      '_FileExplorerScreenStoreBase._updateFileListingRequest',
      context: context);

  @override
  Future<void> _updateFileListingRequest(FileListingRequest request,
      {bool clearSelectedFiles = true}) {
    return _$_updateFileListingRequestAsyncAction.run(() => super
        ._updateFileListingRequest(request,
            clearSelectedFiles: clearSelectedFiles));
  }

  late final _$setCurrentPathAsyncAction = AsyncAction(
      '_FileExplorerScreenStoreBase.setCurrentPath',
      context: context);

  @override
  Future<void> setCurrentPath(String value) {
    return _$setCurrentPathAsyncAction.run(() => super.setCurrentPath(value));
  }

  late final _$setOrderDirOrderByAsyncAction = AsyncAction(
      '_FileExplorerScreenStoreBase.setOrderDirOrderBy',
      context: context);

  @override
  Future<void> setOrderDirOrderBy(
      {required OrderDir? orderDir,
      required OrderBy? orderBy,
      bool clearSelectedFiles = false}) {
    return _$setOrderDirOrderByAsyncAction.run(() => super.setOrderDirOrderBy(
        orderDir: orderDir,
        orderBy: orderBy,
        clearSelectedFiles: clearSelectedFiles));
  }

  late final _$gotoPrevDirectoryAsyncAction = AsyncAction(
      '_FileExplorerScreenStoreBase.gotoPrevDirectory',
      context: context);

  @override
  Future<void> gotoPrevDirectory() {
    return _$gotoPrevDirectoryAsyncAction.run(() => super.gotoPrevDirectory());
  }

  late final _$_popFileListingSourceStackAsyncAction = AsyncAction(
      '_FileExplorerScreenStoreBase._popFileListingSourceStack',
      context: context);

  @override
  Future<void> _popFileListingSourceStack() {
    return _$_popFileListingSourceStackAsyncAction
        .run(() => super._popFileListingSourceStack());
  }

  late final _$_fetchFilesAsyncAction =
      AsyncAction('_FileExplorerScreenStoreBase._fetchFiles', context: context);

  @override
  Future<void> _fetchFiles(
      {bool invalidateCache = false,
      bool? popStackOnError,
      bool clearSelectedFiles = true}) {
    return _$_fetchFilesAsyncAction.run(() => super._fetchFiles(
        invalidateCache: invalidateCache,
        popStackOnError: popStackOnError,
        clearSelectedFiles: clearSelectedFiles));
  }

  late final _$_FileExplorerScreenStoreBaseActionController =
      ActionController(name: '_FileExplorerScreenStoreBase', context: context);

  @override
  void setFileListingSourceStack(List<FileListingRequest> value) {
    final _$actionInfo =
        _$_FileExplorerScreenStoreBaseActionController.startAction(
            name: '_FileExplorerScreenStoreBase.setFileListingSourceStack');
    try {
      return super.setFileListingSourceStack(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

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
  void setSelectedFiles(Map<String, FileListingResponse> value) {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.setSelectedFiles');
    try {
      return super.setSelectedFiles(value);
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Map<String, FileListingResponse> getSelectedFiles() {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.getSelectedFiles');
    try {
      return super.getSelectedFiles();
    } finally {
      _$_FileExplorerScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool isFileSelected(String uniqueKey) {
    final _$actionInfo = _$_FileExplorerScreenStoreBaseActionController
        .startAction(name: '_FileExplorerScreenStoreBase.isFileSelected');
    try {
      return super.isFileSelected(uniqueKey);
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
