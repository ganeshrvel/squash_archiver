import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archiver_ffi/models/list_archives.dart';
import 'package:archiver_ffi/structs/list_archives.dart';
import 'package:archiver_ffi/utils/ffi.dart';
import 'package:archiver_ffi/utils/utils.dart';
import 'package:archiver_ffi/generated/bindings.dart';
import 'package:ffi/ffi.dart';

class StringList extends Struct {
  Pointer<Pointer<Utf8>> list;

  @Int64()
  int size;

  Pointer<StringList> fromList(List<String> arr) {
    final myPointers = arr.map(Utf8.toUtf8).toList();

    // ignore: omit_local_variable_types
    final Pointer<Pointer<Utf8>> list = allocate(count: arr.length);

    for (var i = 0; i < arr.length; i++) {
      list[i] = myPointers[i];
    }

    final pStrList = allocate<StringList>().ref;
    pStrList.list = list;
    pStrList.size = arr.length;

    return pStrList.addressOf;
  }
}

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
    final _ptrToFreeList = <Pointer<Int8>>[];

    final _filename = ffiString(params.filename, _ptrToFreeList);
    final _password = ffiString(params.password, _ptrToFreeList);
    final _orderBy = ffiString(enumToString(params.orderBy), _ptrToFreeList);
    final _orderDir = ffiString(enumToString(params.orderDir), _ptrToFreeList);
    final _listDirectoryPath = ffiString(
      params.listDirectoryPath,
      _ptrToFreeList,
    );
    final _recursive = ffiBool(params.recursive);

    // final _value = Utf8.toUtf8('12345');
    // final _ptr = _value.cast<Int8>();
    // final data  = Uint8List(12);

    // final frameData = allocate<Uint8>(count: data.length); // Allocate a pointer large enough.
    // final pointerList = frameData.asTypedList(data.length); // Create a list that uses our pointer and copy in the image data.
    // pointerList.setAll(0, data);

    //  final ptr = allocate<Int8>(count: 2);
    //  final _value = Utf8.toUtf8('abcd');
    //  ptr.elementAt(0).value = _value;
    //  ptr.elementAt(1).value = 534;
    // final _ptr = ptr.cast<Int8>();

    // final _value = Utf8.toUtf8(value);
    // final _ptr = _value.cast<Int8>();

    // final _pvalue = Utf8.toUtf8('qwerty');
    // final _ptr =   Pointer(_pvalue.cast<Int8>());

    // final frameData = allocate<Uint8>(
    //   count: data.length,
    // ); // Allocate a pointer large enough.
    // final pointerList = frameData.asTypedList(data
    //     .length); // Create a list that uses our pointer and copy in the image data.
    // pointerList.setAll(0, data);

    // final _value = Utf8.toUtf8('qwerty');
    // final _ptr = _value.cast<Int8>();
    // final data  = Uint8List(12);

    // final frameData = allocate<Uint8>(count: data.length); // Allocate a pointer large enough.
    // final pointerList = frameData.asTypedList(data.length); // Create a list that uses our pointer and copy in the image data.
    // pointerList.setAll(0, data);

    //final Int8List byteData = ['qwerty'];

    // final _data = allocate<Int8>(count: 10);
    // final pointerList = _data.asTypedList(10);
    //
    // pointerList.setAll(0, [ptr.cast<Int8>()]);

    //  final _value = Utf8.toUtf8('abcd');
    //  ptr.elementAt(0).value = _value;
    //  ptr.elementAt(1).value = 534;
    // final _ptr = ptr.cast<Int8>();

    // final _value = Utf8.toUtf8('qwerty');
    // final _ptr = _value.cast<Int8>();
    // final _data = allocate<Uint8>(count: 10);
    // final _bytes = _data.asTypedList(10);
    // final _value = Utf8.toUtf8('qwerty');
    // _bytes.

    // final ptr = allocate<Int32>(count: 10);
    // ptr.elementAt(0).value = 'poiuy';

    ///////////////
    // final list1 = 'qwerty'.codeUnits;
    // final nullPtr = '\0'.codeUnits;
    // final list2 = 'poiuyt'.codeUnits;
    // final ptr = allocate<Int8>(count: list1.length + list2.length);
    // final pointerList = ptr.asTypedList(list1.length + list2.length);
    // pointerList.setRange(0, list1.length, list1);
    // pointerList.setRange(0, list2.length, list2);
    ///////////////

    // pointerList.

    // print('object');
    //
    // print(pointerList.toString());

    // final myStrings = ['asdf', 'fsda'];
    // final myPointers = myStrings.map(Utf8.toUtf8).toList();
    // final pointerPointer = allocate(count: myStrings.length);
    // for (var i = 0; i < myStrings.length; i++) {
    //   pointerPointer[i] = myPointers[i];
    // }
    // final result = doWork(pointerPointer);
    // free(pointerPointer);
    // myPointers.forEach(free);
    // print(result);

    //working
    // final myStrings = ['asdf', 'fsda'];
    // final myPointers = myStrings.map(Utf8.toUtf8).toList();
    // final Pointer<Pointer<Utf8>> pointerPointer =
    //     allocate(count: myStrings.length);
    // for (var i = 0; i < myStrings.length; i++) {
    //   pointerPointer[i] = myPointers[i];
    // }
    ///////////////

    // final myStrings = ['asdf', 'fsda'];
    // final myPointers = myStrings.map(Utf8.toUtf8).toList();
    // final list = allocate(count: myStrings.length);
    //
    // for (var i = 0; i < myStrings.length; i++) {
    //   list[i] = myPointers[i];
    // }

    // final pointerPointer = StringList().toList(myStrings);

    ///////////////////// <this is the one

    // final myPointers = arr.map(Utf8.toUtf8).toList();
    // final Pointer<Pointer<Utf8>> list = allocate(count: arr.length);
    //
    // for (var i = 0; i < arr.length; i++) {
    //   list[i] = myPointers[i];
    // }
    //
    // final pStrList = allocate<StringList>().ref;
    // pStrList.list = list;
    // pStrList.length = arr.length;
    //
    // print('=======');
    // print(pStrList.list);
    ///////////////<this is the one



    // final gitIgnorePatternListPtr = StringList().toList(arr);
    final arr = ['asdf', 'fsda'];
    final pStrList = allocate<StringList>().ref;
    final gitIgnorePatternListPtr = pStrList.fromList(arr);

    _squashArchiverLib.ListArchive(
      _nativePort,
      _filename,
      _password,
      _orderBy,
      _orderDir,
      _listDirectoryPath,
      gitIgnorePatternListPtr.address,
      _recursive,
    );

    print('\n=======================');
    return;

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

      // free all FFI allocated values
      _ptrToFreeList.forEach((ptr) {
        free(ptr);
      });

      _squashArchiverLib.FreeListArchiveMemory(_address);

      print('=======================');

      Future.delayed(Duration(seconds: 5), () {
        print('=====delayed check for memory');

        for (var i = 0; i < _totalFiles; i++) {
          final _value = filesPtr.elementAt(i).value;

          print(_value.ref.mode);
          print(_value.ref.size);
          print(_value.ref.isDir); // 1 => true, 0 => 0

          print(result.ref.totalFiles);
        }

        print(result.ref.totalFiles);
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
