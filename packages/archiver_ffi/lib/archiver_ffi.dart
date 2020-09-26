import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:archiver_ffi/models/list_archives_request.dart';
import 'package:archiver_ffi/models/list_archives_response.dart';
import 'package:archiver_ffi/structs/list_archives.dart';
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

  Future<DC<Exception, ListArchiveResponse>> listArchive(
      ListArchiveRequest params) async {
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

    final _completer = Completer<DC<Exception, ListArchiveResponse>>();

    StreamSubscription _requestsSub;
    _requestsSub = _requests.listen((address) {
      final _address = address as int;
      final result = Pointer<ArcFileInfoResult>.fromAddress(_address);

      final _error = result.ref.error;
      DC<Exception, ListArchiveResponse> _dc;

      if (_error.ref.error.address != 0) {

        _dc = handleError<ListArchiveResponse>(
          error: _error.ref.error.ref.toString(),
          errorType: _error.ref.errorType.ref.toString(),
        );
      } else {
        final filesPtr = result.ref.files;
        final _totalFiles = result.ref.totalFiles;

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
        final _listArchiveResult = ListArchiveResponse(
          totalFiles: result.ref.totalFiles,
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
}
