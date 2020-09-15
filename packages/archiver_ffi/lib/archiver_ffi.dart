import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:archiver_ffi/models/list_archives.dart';
import 'package:archiver_ffi/structs/list_archives.dart';
import 'package:archiver_ffi/utils/ffi.dart';
import 'package:archiver_ffi/utils/utils.dart';
import 'package:archiver_ffi/generated/bindings.dart';
import 'package:ffi/ffi.dart';

class ArchiverFfi {
  SquashArchiverLib _squashArchiverLib;

  ArchiverFfi({bool isTest}) {
    final _isTest = isTest ?? false;

    final _dylib = DynamicLibrary.open(getNativeLib(fullPath: _isTest));

    _squashArchiverLib = SquashArchiverLib(_dylib);
    _squashArchiverLib.InitNewNativeDartPort(NativeApi.initializeApiDLData);
  }

  Future<void> listArchive(ListArchiver params) async {
    final _requests = ReceivePort();
    final _nativePort = _requests.sendPort.nativePort;

    // collect all pointers to be freed later
    final _ptrToFreeList = <Pointer<NativeType>>[];

    final _filename = ffiString(params.filename, _ptrToFreeList);
    final _password = ffiString(params.password, _ptrToFreeList);
    final _orderBy = ffiString(enumToString(params.orderBy), _ptrToFreeList);
    final _orderDir = ffiString(enumToString(params.orderDir), _ptrToFreeList);
    final _listDirectoryPath = ffiString(
      params.listDirectoryPath,
      _ptrToFreeList,
    );
    final _pGitIgnorePattern = ffiStringList(
      params.gitIgnorePattern,
      _ptrToFreeList,
    );
    final _recursive = ffiBool(params.recursive);

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

    StreamSubscription _requestsSub;
    print('=======================');
    _requestsSub = _requests.listen((address) {
      final _address = address as int;

      final result = Pointer<ArcFileInfoResult>.fromAddress(_address);

      final _error = result.ref.error;
      if (_error.ref.error.address != 0) {
        print(_error.ref.error.ref.toString());
        print(_error.ref.errorType.ref.toString());

        return;
      }

      final filesPtr = result.ref.files;
      final totalFilesPtr = result.ref.totalFiles;

      final _totalFiles = totalFilesPtr;

      for (var i = 0; i < _totalFiles; i++) {
        print('==========index=============');
        print('index:');
        print(i);
        print('\n');

        final _value = filesPtr.elementAt(i).value;

        print(_value.ref.mode);
        print(_value.ref.size);
        print(_value.ref.modTime.ref.toString());
        print(_value.ref.isDir); // 1 => true, 0 => 0
        print(_value.ref.name.ref.toString());
        print(_value.ref.fullPath.ref.toString());

        print(result.ref.totalFiles);
      }


      print(_ptrToFreeList);
      print(_ptrToFreeList.length);

      // free all FFI allocated values
      _ptrToFreeList.forEach((ptr) {
        free(ptr);
      });

      _squashArchiverLib.FreeListArchiveMemory(_address);

      print('=======================');

      Future.delayed(Duration(seconds: 2), () {
        print('=====delayed check for memory');

        for (var i = 0; i < _totalFiles; i++) {
          final _value = filesPtr.elementAt(i).value;

          print(_value.ref.mode);
          print(_value.ref.size);
          print(_value.ref.isDir); // 1 => true, 0 => 0

          print(result.ref.totalFiles);
        }

        print(result.ref.totalFiles);

        final _tt = _pGitIgnorePattern.ref.list.elementAt(1);
        print(_tt.value.elementAt(0).toString());
      });

/*
      Future.delayed(Duration(seconds: 3), () {
        final result = Pointer<ArcFileInfoResult>.fromAddress(_address);

        final _string_list_ptr = result.ref.files;
        //  final infoPtr = result.ref.info;

        final _value = _string_list_ptr.elementAt(0).value;

        print(_value.ref.Mode);
        print(_value.ref.size);
        print(_value.ref.modTime.ref.toString());
        print(_value.ref.isDir); // 1 => true, 0 => 0
        print(_value.ref.name.ref.toString());
        print(_value.ref.fullPath.ref.toString());
      });
*/

      // _requests.close();
      // _requestsSub.cancel();
      // _squashArchiverLib.CloseNativeDartPort(_nativePort);

      // final result = Pointer<Work>.fromAddress(_address);
      //
      // print('=======================');
      // print('WORK data');
      // print('name: ');
      // print(work.ref.name.ref.toString());
      // print('age: ');
      // print(work.ref.age);
      //
      // final _string_list_ptr = work.ref.string_list;
      //
      // var count = 0;
      //
      // print('string_list: ');
      // while (true) {
      //   final _value = _string_list_ptr.elementAt(count).value;
      //
      //   if (_value.address == 0) {
      //     break;
      //   }
      //
      //   print(_value.ref.toString());
      //
      //   count += 1;
      // }
      //

      print('=======================');
    });
  }
}
