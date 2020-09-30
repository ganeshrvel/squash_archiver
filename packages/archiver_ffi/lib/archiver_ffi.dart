import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:archiver_ffi/models/file_info.dart';
import 'package:archiver_ffi/models/is_archive_encrypted.dart';
import 'package:archiver_ffi/models/list_archive.dart';
import 'package:archiver_ffi/models/pack_files.dart';
import 'package:archiver_ffi/models/unpack_files.dart';
import 'package:archiver_ffi/structs/is_archive_encrypted.dart';
import 'package:archiver_ffi/structs/list_archive.dart';
import 'package:archiver_ffi/structs/pack_files.dart';
import 'package:archiver_ffi/structs/unpack_files.dart';
import 'package:archiver_ffi/utils/ffi.dart';
import 'package:archiver_ffi/utils/functs.dart';
import 'package:archiver_ffi/utils/handle_errors.dart';
import 'package:archiver_ffi/utils/utils.dart';
import 'package:archiver_ffi/generated/bindings.dart';
import 'package:data_channel/data_channel.dart';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

class ArchiverFfi {
  SquashArchiverLib _squashArchiverLib;

  ArchiverFfi({bool isTest}) {
    final _isTest = isTest ?? false;

    final _dylib = DynamicLibrary.open(getNativeLib(fullPath: _isTest));

    _squashArchiverLib = SquashArchiverLib(_dylib);
    _squashArchiverLib.InitNewNativeDartPort(NativeApi.initializeApiDLData);
  }

  // List files in an archive
  Future<DC<Exception, ListArchiveResult>> listArchive(
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

    final _completer = Completer<DC<Exception, ListArchiveResult>>();

    StreamSubscription _requestsSub;
    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final _result =
          Pointer<ArchiveFileInfoResultStruct>.fromAddress(_address);

      final _error = _result.ref.error;

      DC<Exception, ListArchiveResult> _dc;

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

      _completer.complete(_dc);

      // free all FFI allocated values
      _ptrToFreeList.forEach(free);
      _squashArchiverLib.FreeListArchiveMemory(_address);

      _requests.close();
      _requestsSub.cancel();
      _squashArchiverLib.CloseNativeDartPort(_nativePort);
    });

    return _completer.future;
  }

  // Check whether an archive is encrypted
  Future<DC<Exception, IsArchiveEncryptedResult>> isArchiveEncrypted(
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

    final _completer = Completer<DC<Exception, IsArchiveEncryptedResult>>();

    StreamSubscription _requestsSub;

    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final _result =
          Pointer<IsArchiveEncryptedResultStruct>.fromAddress(_address);

      final _error = _result.ref.error;

      DC<Exception, IsArchiveEncryptedResult> _dc;

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

      _completer.complete(_dc);

      // free all FFI allocated values
      _ptrToFreeList.forEach(free);
      _squashArchiverLib.FreeIsArchiveEncryptedMemory(_address);

      _requests.close();
      _requestsSub.cancel();
      _squashArchiverLib.CloseNativeDartPort(_nativePort);
    });

    return _completer.future;
  }

  // Pack files
  Future<DC<Exception, PackFilesResult>> packFiles(
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

    final _completer = Completer<DC<Exception, PackFilesResult>>();

    StreamSubscription _requestsSub;

    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final _result = Pointer<PackFilesStruct>.fromAddress(_address);

      DC<Exception, PackFilesResult> _dc;

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
        _completer.complete(_dc);

        // free all FFI allocated values
        _ptrToFreeList.forEach(free);
        _squashArchiverLib.FreePackFilesMemory(_address);

        _requests.close();
        _requestsSub.cancel();
        _squashArchiverLib.CloseNativeDartPort(_nativePort);
      }
    });

    return _completer.future;
  }

  // Unpack files
  Future<DC<Exception, UnpackFilesResult>> unpackFiles(
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

    final _completer = Completer<DC<Exception, UnpackFilesResult>>();

    StreamSubscription _requestsSub;

    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final _result = Pointer<UnpackFilesStruct>.fromAddress(_address);

      DC<Exception, UnpackFilesResult> _dc;

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
        _completer.complete(_dc);

        // free all FFI allocated values
        _ptrToFreeList.forEach(free);
        _squashArchiverLib.FreeUnpackFilesMemory(_address);

        _requests.close();
        _requestsSub.cancel();
        _squashArchiverLib.CloseNativeDartPort(_nativePort);
      }
    });

    return _completer.future;
  }
}
