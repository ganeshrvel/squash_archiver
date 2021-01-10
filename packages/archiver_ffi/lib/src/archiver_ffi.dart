import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:archiver_ffi/src/exceptions/exceptions.dart';
import 'package:archiver_ffi/src/models/archive_file_info.dart';
import 'package:archiver_ffi/src/models/is_archive_encrypted.dart';
import 'package:archiver_ffi/src/models/list_archive.dart';
import 'package:archiver_ffi/src/models/pack_files.dart';
import 'package:archiver_ffi/src/models/unpack_files.dart';
import 'package:archiver_ffi/src/structs/is_archive_encrypted.dart';
import 'package:archiver_ffi/src/structs/list_archive.dart';
import 'package:archiver_ffi/src/structs/pack_files.dart';
import 'package:archiver_ffi/src/structs/unpack_files.dart';
import 'package:archiver_ffi/src/utils/ffi.dart';
import 'package:archiver_ffi/src/utils/functs.dart';
import 'package:archiver_ffi/src/utils/handle_errors.dart';
import 'package:archiver_ffi/src/utils/utils.dart';
import 'package:archiver_ffi/src/generated/bindings.dart';
import 'package:data_channel/data_channel.dart';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

class ArchiverFfi {
  SquashArchiverLib _squashArchiverLib;

  factory ArchiverFfi({bool isTest, String libAbsPath}) {
    final _isTest = isTest ?? false;

    DynamicLibrary _dylib;
    if (isNotNullOrEmpty(libAbsPath)) {
      _dylib = DynamicLibrary.open(libAbsPath);
    } else {
      _dylib = DynamicLibrary.open(getNativeLib(fullPath: _isTest));
    }

    ArchiverFfi._instance._squashArchiverLib = SquashArchiverLib(_dylib);
    ArchiverFfi._instance._squashArchiverLib.InitNewNativeDartPort(
      NativeApi.initializeApiDLData,
    );

    return _instance;
  }

  ArchiverFfi._privateConstructor();

  static final ArchiverFfi _instance = ArchiverFfi._privateConstructor();

  // List files in an archive
  Future<DC<ArchiverException, ListArchiveResult>> listArchive(
    ListArchive params,
  ) async {
    final _requests = ReceivePort();
    final _nativePort = _requests.sendPort.nativePort;

    // collect all pointers to be freed later
    final _ptrToFreeList = <Pointer<NativeType>>[];

    final _filename = toFfiString(params.filename, _ptrToFreeList);
    final _password = toFfiString(params.password, _ptrToFreeList);
    final _orderBy = toFfiString(enumToString(params.orderBy), _ptrToFreeList);
    final _orderDir =
        toFfiString(enumToString(params.orderDir), _ptrToFreeList);
    final _listDirectoryPath = toFfiString(
      params.listDirectoryPath,
      _ptrToFreeList,
    );
    final _pGitIgnorePattern = toFfiStringList(
      params.gitIgnorePattern,
      _ptrToFreeList,
    );
    final _recursive = toFfiBool(params.recursive);

    _squashArchiverLib.ListArchive(
      _nativePort,
      _filename,
      _password,
      _orderBy,
      _orderDir,
      _listDirectoryPath,
      _pGitIgnorePattern.address,
      _recursive,
    );

    final _completer = Completer<DC<ArchiverException, ListArchiveResult>>();

    StreamSubscription _requestsSub;
    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final _result =
          Pointer<ArchiveFileInfoResultStruct>.fromAddress(_address);

      final _error = _result.ref.error;

      DC<ArchiverException, ListArchiveResult> _dc;

      if (_error.ref.error.address != 0) {
        _dc = handleError<ListArchiveResult>(_error);
      } else {
        final filesPtr = _result.ref.files;
        final _totalFiles = _result.ref.totalFiles;

        final _files = <FileInfo>[];

        for (var i = 0; i < _totalFiles; i++) {
          final _value = filesPtr.elementAt(i).value;

          final _file = FileInfo(
            mode: _value.ref.mode,
            size: _value.ref.size,
            isDir: fromFfiBool(_value.ref.isDir),
            modTime: _value.ref.modTime.ref.toString(),
            name: _value.ref.name.ref.toString(),
            fullPath: _value.ref.fullPath.ref.toString(),
            parentPath: _value.ref.parentPath.ref.toString(),
            extension: _value.ref.extension.ref.toString(),
          );

          _files.add(_file);
        }

        final _listArchiveResult = ListArchiveResult(
          totalFiles: _result.ref.totalFiles,
          files: _files,
        );

        _dc = DC(
          data: _listArchiveResult,
          error: null,
        );
      }

      // free all FFI allocated values
      _ptrToFreeList.forEach(free);
      _squashArchiverLib.FreeListArchiveMemory(_address);

      _requests.close();
      _requestsSub.cancel();
      _squashArchiverLib.CloseNativeDartPort(_nativePort);

      _completer.complete(_dc);
    });

    return _completer.future;
  }

  // Check whether an archive is encrypted
  Future<DC<ArchiverException, IsArchiveEncryptedResult>> isArchiveEncrypted(
    IsArchiveEncrypted params,
  ) async {
    final _requests = ReceivePort();
    final _nativePort = _requests.sendPort.nativePort;

    // collect all pointers to be freed later
    final _ptrToFreeList = <Pointer<NativeType>>[];

    final _filename = toFfiString(params.filename, _ptrToFreeList);
    final _password = toFfiString(params.password, _ptrToFreeList);

    _squashArchiverLib.IsArchiveEncrypted(
      _nativePort,
      _filename,
      _password,
    );

    final _completer =
        Completer<DC<ArchiverException, IsArchiveEncryptedResult>>();

    StreamSubscription _requestsSub;

    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final _result =
          Pointer<IsArchiveEncryptedResultStruct>.fromAddress(_address);

      final _error = _result.ref.error;

      DC<ArchiverException, IsArchiveEncryptedResult> _dc;

      if (_error.ref.error.address != 0) {
        _dc = handleError<IsArchiveEncryptedResult>(_error);
      } else {
        final _isEncrypted = _result.ref.isEncrypted;
        final _isValidPassword = _result.ref.isValidPassword;

        final _isArchiveEncryptedResult = IsArchiveEncryptedResult(
          isEncrypted: fromFfiBool(_isEncrypted),
          isValidPassword: fromFfiBool(_isValidPassword),
        );

        _dc = DC(
          data: _isArchiveEncryptedResult,
          error: null,
        );
      }

      // free all FFI allocated values
      _ptrToFreeList.forEach(free);
      _squashArchiverLib.FreeIsArchiveEncryptedMemory(_address);

      _requests.close();
      _requestsSub.cancel();
      _squashArchiverLib.CloseNativeDartPort(_nativePort);

      _completer.complete(_dc);
    });

    return _completer.future;
  }

  // Pack files
  Future<DC<ArchiverException, PackFilesResult>> packFiles(
    PackFiles params, {
    Function({
      @required String startTime,
      @required String currentFilename,
      @required int totalFiles,
      @required int progressCount,
      @required double progressPercentage,
    })
        onProgress,
  }) async {
    final _requests = ReceivePort();
    final _nativePort = _requests.sendPort.nativePort;

    // collect all pointers to be freed later
    final _ptrToFreeList = <Pointer<NativeType>>[];

    final _filename = toFfiString(params.filename, _ptrToFreeList);
    final _password = toFfiString(params.password, _ptrToFreeList);
    final _pGitIgnorePattern = toFfiStringList(
      params.gitIgnorePattern,
      _ptrToFreeList,
    );
    final _pFileList = toFfiStringList(
      params.fileList,
      _ptrToFreeList,
    );

    _squashArchiverLib.PackFiles(
      _nativePort,
      _filename,
      _password,
      _pGitIgnorePattern.address,
      _pFileList.address,
    );

    final _completer = Completer<DC<ArchiverException, PackFilesResult>>();

    StreamSubscription _requestsSub;

    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final _result = Pointer<PackFilesStruct>.fromAddress(_address);

      DC<ArchiverException, PackFilesResult> _dc;

      final _ended = fromFfiBool(_result.ref.ended);

      final _error = _result.ref.error;
      if (_error.ref.error.address != 0) {
        _dc = handleError<PackFilesResult>(_error);
      } else {
        const _packFilesResult = PackFilesResult(success: true);

        _dc = DC(
          data: _packFilesResult,
          error: null,
        );

        if (isNotNull(onProgress)) {
          onProgress(
            progressPercentage: _result.ref.progressPercentage,
            progressCount: _result.ref.progressCount,
            startTime: _result.ref.startTime.ref.toString(),
            totalFiles: _result.ref.totalFiles,
            currentFilename: _result.ref.currentFilename.ref.toString(),
          );
        }
      }

      // free the memory and complete the task if [_ended] flag is true
      if (_ended) {
        // free all FFI allocated values
        _ptrToFreeList.forEach(free);
        _squashArchiverLib.FreePackFilesMemory(_address);

        _requests.close();
        _requestsSub.cancel();
        _squashArchiverLib.CloseNativeDartPort(_nativePort);

        _completer.complete(_dc);
      }
    });

    return _completer.future;
  }

  // Unpack files
  Future<DC<ArchiverException, UnpackFilesResult>> unpackFiles(
    UnpackFiles params, {
    Function({
      @required String startTime,
      @required String currentFilename,
      @required int totalFiles,
      @required int progressCount,
      @required double progressPercentage,
    })
        onProgress,
  }) async {
    final _requests = ReceivePort();
    final _nativePort = _requests.sendPort.nativePort;

    // collect all pointers to be freed later
    final _ptrToFreeList = <Pointer<NativeType>>[];

    final _filename = toFfiString(params.filename, _ptrToFreeList);
    final _password = toFfiString(params.password, _ptrToFreeList);
    final _destination = toFfiString(params.destination, _ptrToFreeList);
    final _pGitIgnorePattern = toFfiStringList(
      params.gitIgnorePattern,
      _ptrToFreeList,
    );
    final _pFileList = toFfiStringList(
      params.fileList,
      _ptrToFreeList,
    );

    _squashArchiverLib.UnpackFiles(
      _nativePort,
      _filename,
      _password,
      _destination,
      _pGitIgnorePattern.address,
      _pFileList.address,
    );

    final _completer = Completer<DC<ArchiverException, UnpackFilesResult>>();

    StreamSubscription _requestsSub;

    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final _result = Pointer<UnpackFilesStruct>.fromAddress(_address);

      DC<ArchiverException, UnpackFilesResult> _dc;

      final _ended = fromFfiBool(_result.ref.ended);

      final _error = _result.ref.error;
      if (_error.ref.error.address != 0) {
        _dc = handleError<UnpackFilesResult>(_error);
      } else {
        const _unpackFilesResult = UnpackFilesResult(success: true);

        _dc = DC(
          data: _unpackFilesResult,
          error: null,
        );

        if (isNotNull(onProgress)) {
          onProgress(
            progressPercentage: _result.ref.progressPercentage,
            progressCount: _result.ref.progressCount,
            startTime: _result.ref.startTime.ref.toString(),
            totalFiles: _result.ref.totalFiles,
            currentFilename: _result.ref.currentFilename.ref.toString(),
          );
        }
      }

      // free the memory and complete the task if [_ended] flag is true
      if (_ended) {
        // free all FFI allocated values
        _ptrToFreeList.forEach(free);
        _squashArchiverLib.FreeUnpackFilesMemory(_address);

        _requests.close();
        _requestsSub.cancel();
        _squashArchiverLib.CloseNativeDartPort(_nativePort);

        _completer.complete(_dc);
      }
    });

    return _completer.future;
  }
}
