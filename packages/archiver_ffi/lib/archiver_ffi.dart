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
  int Mode;

  @Int64()
  int Size;

  @Int8()
  int IsDir;

  Pointer<Utf8> ModTime;

  Pointer<Utf8> Name;

  Pointer<Utf8> FullPath;

  factory ArcFileInfo.allocate(
    int Mode,
    int Size,
    int IsDir,
    Pointer<Utf8> ModTime,
    Pointer<Utf8> Name,
    Pointer<Utf8> FullPath,
  ) =>
      allocate<ArcFileInfo>().ref
        ..Mode = Mode
        ..Size = Size
        ..IsDir = IsDir
        ..ModTime = ModTime
        ..Name = Name
        ..FullPath = FullPath;
}

class ArcFileInfoResult extends Struct {
  Pointer<Pointer<ArcFileInfo>> files;
}

class ArchiverFfi {
  SquashArchiverLib _squashArchiverLib;

  ArchiverFfi({bool isTest}) {
    final _isTest = isTest ?? false;

    final _dylib = DynamicLibrary.open(getNativeLib(fullpath: _isTest));

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

    _requestsSub = _requests.listen((address) {
      final _address = address as int;

      final work = Pointer<ArcFileInfoResult>.fromAddress(_address);

      final _string_list_ptr = work.ref.files;
      //  final infoPtr = work.ref.info;

      final _value = _string_list_ptr.elementAt(0).value;

      print(_value.ref.Mode);
      print(_value.ref.Size);
      print(_value.ref.ModTime.ref.toString());
      print(_value.ref.IsDir); // 1 => true, 0 => 0
      print(_value.ref.Name.ref.toString());
      print(_value.ref.FullPath.ref.toString());

      _ptrToFreeList.forEach((ptr) {
        free(ptr);
      });

      _requests.close();
      _requestsSub.cancel();
      _squashArchiverLib.CloseNativeDartPort(_nativePort);

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
      // _squashArchiverLib.FreeWorkStructMemory(Pointer<Int64>.fromAddress(
      //   _address,
      // ));

      print('=======================');
    });
  }
}
