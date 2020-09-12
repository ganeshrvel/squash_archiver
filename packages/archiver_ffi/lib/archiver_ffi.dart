import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:archiver_ffi/test_utils.dart';
import 'package:archiver_ffi/utils.dart';
import 'package:archiver_ffi/generated/bindings.dart';
import 'package:ffi/ffi.dart';

enum OrderBy {
  size,
  modTime,
  name,
  fullPath,
}

enum OrderDir {
  asc,
  desc,
  none,
}

class ArcFileInfo extends Struct {
  @Int32()
  int mode;

  @Int64()
  int size;

  @Int8()
  int isDir;

  Pointer<Utf8> modTime;

  Pointer<Utf8> name;

  Pointer<Utf8> fullPath;

  factory ArcFileInfo.allocate(
    int mode,
    int size,
    int isDir,
    Pointer<Utf8> modTime,
    Pointer<Utf8> name,
    Pointer<Utf8> fullPath,
  ) =>
      allocate<ArcFileInfo>().ref
        ..mode = mode
        ..size = size
        ..isDir = isDir
        ..modTime = modTime
        ..name = name
        ..fullPath = fullPath;
}

class ArcFileInfoResult extends Struct {
  Pointer<Pointer<ArcFileInfo>> files;

  @Int64()
  int totalFiles;

  factory ArcFileInfoResult.allocate(
    Pointer<Pointer<ArcFileInfo>> files,
    int totalFiles,
  ) =>
      allocate<ArcFileInfoResult>().ref
        ..files = files
        ..totalFiles = totalFiles;
}

class ArchiverFfi {
  SquashArchiverLib _squashArchiverLib;

  ArchiverFfi({bool isTest}) {
    final _isTest = isTest ?? false;

    final _dylib = DynamicLibrary.open(getNativeLib(fullPath: _isTest));

    _squashArchiverLib = SquashArchiverLib(_dylib);
    _squashArchiverLib.InitNewNativeDartPort(NativeApi.initializeApiDLData);
  }

  Future<void> listArchive() async {
    // collect all pointers to be freed later
    final _ptrToFreeList = <Pointer<Int8>>[];

    final _requests = ReceivePort();
    final _nativePort = _requests.sendPort.nativePort;

    final _filename = ffiString(
      getTestMocksAsset('mock_test_file1.zip'),
      _ptrToFreeList,
    );
    final _password = ffiString('', _ptrToFreeList);
    final _orderBy = ffiString(enumToString(OrderBy.fullPath), _ptrToFreeList);
    final _orderDir = ffiString(enumToString(OrderDir.asc), _ptrToFreeList);
    final _listDirectoryPath = ffiString('', _ptrToFreeList);
    final _recursive = ffiBool(true);

    _squashArchiverLib.ListArchive(
      _nativePort,
      _filename,
      _password,
      _orderBy,
      _orderDir,
      _listDirectoryPath,
      _recursive,
    );

    StreamSubscription _requestsSub;
    print('=======================');
    _requestsSub = _requests.listen((address) {
      final _address = address as int;

      final work = Pointer<ArcFileInfoResult>.fromAddress(_address);

      final filesPtr = work.ref.files;
      final totalFilesPtr = work.ref.totalFiles;
      //  final infoPtr = work.ref.info;

      final _value = filesPtr.elementAt(0).value;

      print(_value.ref.mode);
      print(_value.ref.size);
      print(_value.ref.modTime.ref.toString());
      print(_value.ref.isDir); // 1 => true, 0 => 0
      print(_value.ref.name.ref.toString());
      print(_value.ref.fullPath.ref.toString());

      print(work.ref.totalFiles);

      final _totalFiles = totalFilesPtr;

      _ptrToFreeList.forEach((ptr) {
        free(ptr);
      });

      _squashArchiverLib.FreeListArchiveMemory(_address);

      print('=======================');

      Future.delayed(Duration(seconds: 5), () {
        print('=====delayed check for memory');
        print(_value.ref.mode);
        print(_value.ref.size);
        // print(_value.ref.modTime.ref.toString());
        print(_value.ref.isDir); // 1 => true, 0 => 0
        // print(_value.ref.name.ref.toString());
        // print(_value.ref.fullPath.ref.toString());

        print(work.ref.totalFiles);
      });

/*
      Future.delayed(Duration(seconds: 3), () {
        final work = Pointer<ArcFileInfoResult>.fromAddress(_address);

        final _string_list_ptr = work.ref.files;
        //  final infoPtr = work.ref.info;

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

      // final work = Pointer<Work>.fromAddress(_address);
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
