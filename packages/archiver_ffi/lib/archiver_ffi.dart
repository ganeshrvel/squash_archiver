import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:archiver_ffi/models/file_info.dart';
import 'package:archiver_ffi/models/is_archive_encrypted.dart';
import 'package:archiver_ffi/models/list_archive.dart';
import 'package:archiver_ffi/structs/is_archive_encrypted.dart';
import 'package:archiver_ffi/structs/list_archive.dart';
import 'package:archiver_ffi/utils/ffi.dart';
import 'package:archiver_ffi/utils/handle_errors.dart';
import 'package:archiver_ffi/utils/utils.dart';
import 'package:archiver_ffi/generated/bindings.dart';
import 'package:data_channel/data_channel.dart';
import 'package:ffi/ffi.dart';

class ArchiverFfi {
  SquashArchiverLib _squashArchiverLib;

  ArchiverFfi({bool isTest}) {
    final _isTest = isTest ?? false;

    final _dylib = DynamicLibrary.open(getNativeLib(fullPath: _isTest));

    _squashArchiverLib = SquashArchiverLib(_dylib);
    _squashArchiverLib.InitNewNativeDartPort(NativeApi.initializeApiDLData);
  }

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
}
