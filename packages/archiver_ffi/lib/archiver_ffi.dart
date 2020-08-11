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

class ArchiverFfi {
  SquashArchiverLib _squashArchiverLib;

  ArchiverFfi() {
    final _dylib = DynamicLibrary.open(path.join(Directory.current.path,
        'native', 'archiver_lib', AppFiles.ARCHIVER_FFI_LIB));
    //final _dylib = DynamicLibrary.open(AppFiles.ARCHIVER_FFI_LIB); //todo

    _squashArchiverLib = SquashArchiverLib(_dylib);
  }

  Future<void> run() async {
    _squashArchiverLib.InitializeDartApi(NativeApi.initializeApiDLData);

    final interactiveCppRequests = ReceivePort();

    final interactiveCppSub = interactiveCppRequests.listen((data) {
      final work = Pointer<Work>.fromAddress(data as int);
      print(work.ref.name.ref.toString());
      print(work.ref.age);

      final _string_list_ptr = work.ref.string_list;

      var count = 0;

      while (true) {
        final _value = _string_list_ptr.elementAt(count).value;

        if (_value.address == 0) {
          break;
        }

        print(_value.ref.toString());

        count += 1;
      }

      free(work);
    });

    final nativePort = interactiveCppRequests.sendPort.nativePort;

    _squashArchiverLib.StartWork(nativePort);

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
