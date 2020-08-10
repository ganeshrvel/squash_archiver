import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';
import 'dart:isolate';
import 'package:archiver_ffi/constants/app_files.dart';
import 'package:archiver_ffi/generated/bindings.dart';
import 'package:path/path.dart' as path;

class Work extends Struct {
  @Int64()
  int a;

  @Int64()
  int b;

  factory Work.allocate(int a, int b) => allocate<Work>().ref
    ..a = a
    ..b = b;
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

      print(data);

      /*final work = Pointer<Work>.fromAddress(data as int);
      print(work.ref.a);
      print(work.ref.b);*/
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
