import 'dart:ffi';
import 'dart:isolate';

import 'package:squash_archiver/constants/app_files.dart';

typedef StartWorkType = Void Function(Int64 port);
typedef StartWorkFunc = void Function(int port);

class ArchiverFfi {
  DynamicLibrary _dylib;

  ArchiverFfi() {
    _dylib = DynamicLibrary.open(AppFiles.ARCHIVER_FFI_LIB);
  }

  Future<void> run() async {
    final initializeApi = _dylib.lookupFunction<IntPtr Function(Pointer<Void>),
        int Function(Pointer<Void>)>('InitializeDartApi');
    if (initializeApi(NativeApi.initializeApiDLData) != 0) {
      throw 'Failed to initialize Dart API';
    }

    final interactiveCppRequests = ReceivePort()
      ..listen((data) {
        print('Received: ${data} from Go');
      });
    final nativePort = interactiveCppRequests.sendPort.nativePort;

    final startWork = _dylib
        .lookup<NativeFunction<StartWorkType>>('StartWork')
        .asFunction<StartWorkFunc>();
    startWork(nativePort);

    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      print('Dart: 2 seconds passed');
    }
  }
}
