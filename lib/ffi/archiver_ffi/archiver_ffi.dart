import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as path;

import 'package:squash_archiver/constants/app_files.dart';

typedef StartWorkType = Void Function(Int64 port);
typedef StartWorkFunc = void Function(int port);

class ArchiverFfi {
  DynamicLibrary _dylib;

  ArchiverFfi() {
    _dylib = DynamicLibrary.open(path.join(Directory.current.path, '../../../',
        'native', 'archiver_lib', AppFiles.ARCHIVER_FFI_LIB));
    //_dylib = DynamicLibrary.open(AppFiles.ARCHIVER_FFI_LIB); //todo
  }

  Future<void> run() async {
    final initializeApi = _dylib.lookupFunction<IntPtr Function(Pointer<Void>),
        int Function(Pointer<Void>)>('InitializeDartApi');

    if (initializeApi(NativeApi.initializeApiDLData) != 0) {
      throw 'Failed to initialize Dart API';
    }

    final interactiveCppRequests = ReceivePort();

    final interactiveCppSub = interactiveCppRequests.listen((data) {
      print('Received: ${data} from Go');
    });

    final nativePort = interactiveCppRequests.sendPort.nativePort;

    final startWork = _dylib
        .lookup<NativeFunction<StartWorkType>>('StartWork')
        .asFunction<StartWorkFunc>();

    startWork(nativePort);

    await Future.delayed(const Duration(seconds: 10), () {
      interactiveCppSub.cancel();
      interactiveCppRequests.close();
    });

    for (var i = 0; i < 5;) {
      await Future.delayed(const Duration(seconds: 2));
      print('Dart: 2 seconds passed');
    }
  }
}
