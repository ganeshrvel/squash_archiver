import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';
import 'dart:isolate';
import 'package:archiver_ffi/constants/app_files.dart';
import 'package:archiver_ffi/generated/bindings.dart';
import 'package:path/path.dart' as path;

class Work extends Struct {
  Pointer<Utf8> name;

  @Int64()
  int age;

  Pointer<Pointer<Utf8>> string_list;

  factory Work.allocate(
          Pointer<Utf8> name, int age, Pointer<Pointer<Utf8>> string_list) =>
      allocate<Work>().ref
        ..name = name
        ..age = age
        ..string_list = string_list;
}

class User extends Struct {
  Pointer<Utf8> email;

  @Int64()
  int id;

  Pointer<Pointer<Utf8>> string_list;

  factory User.allocate(Pointer<Utf8> email, int id) => allocate<User>().ref
    ..email = email
    ..id = id;
}

class ArchiverFfi {
  SquashArchiverLib _squashArchiverLib;

  ArchiverFfi() {
    final _dylib = DynamicLibrary.open(path.join(Directory.current.path,
        'native', 'archiver_lib', AppFiles.ARCHIVER_FFI_LIB));
    //final _dylib = DynamicLibrary.open(AppFiles.ARCHIVER_FFI_LIB); //todo

    _squashArchiverLib = SquashArchiverLib(_dylib);
    _squashArchiverLib.InitializeDartApi(NativeApi.initializeApiDLData);
  }

  Future<void> getWorkData() async {
    final interactiveCppRequests = ReceivePort();

    final nativePort = interactiveCppRequests.sendPort.nativePort;

    _squashArchiverLib.StartWork(nativePort);

    var _isClosed = false;

    final interactiveCppSub = interactiveCppRequests.listen((address) {
      final _address = address as int;

      final work = Pointer<Work>.fromAddress(_address);

      print('=======================');
      print('user data');
      print('name: ');
      print(work.ref.name.ref.toString());
      print('age: ');
      print(work.ref.age);

      final _string_list_ptr = work.ref.string_list;

      var count = 0;

      print('string_list: ');
      while (true) {
        final _value = _string_list_ptr.elementAt(count).value;

        if (_value.address == 0) {
          break;
        }

        print(_value.ref.toString());

        count += 1;
      }

      _squashArchiverLib.FreeWorkStructMemory(Pointer<Int64>.fromAddress(
        _address,
      ));

      print('=======================');
    });

    Future.delayed(const Duration(seconds: 7), () {
      interactiveCppSub.cancel();
      interactiveCppRequests.close();
      _squashArchiverLib.CloseNativeDartPort(nativePort);
      print("Closing 'Work'");

      _isClosed = true;
    });

    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      print('Dart: 2 seconds passed');

      if (_isClosed) {
        break;
      }
    }
  }

  Future<void> getUserData() async {
    _squashArchiverLib.InitializeDartApi(NativeApi.initializeApiDLData);

    final interactiveCppRequests = ReceivePort();

    final interactiveCppSub = interactiveCppRequests.listen((address) {
      final _address = address as int;

      final user = Pointer<User>.fromAddress(_address);

      print('=======================');
      print('user data');
      print('email: ');
      print(user.ref.email.ref.toString());
      print('id: ');
      print(user.ref.id);

      _squashArchiverLib.FreeUserStructMemory(Pointer<Int64>.fromAddress(
        _address,
      ));

      print('=======================');
    });

    final nativePort = interactiveCppRequests.sendPort.nativePort;

    _squashArchiverLib.StartUser(nativePort);

    Future.delayed(const Duration(seconds: 10), () {
      interactiveCppSub.cancel();
      interactiveCppRequests.close();
    });

    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      print('Dart: 2 seconds passed');
    }
  }
}
