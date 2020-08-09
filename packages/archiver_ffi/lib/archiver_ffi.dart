import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:archiver_ffi/constants/app_files.dart';
import 'package:archiver_ffi/generated_bindings.dart';
import 'package:path/path.dart' as path;

typedef StartWorkType = Void Function(Int64 port);
typedef StartWorkFunc = void Function(int port);

class ArchiverFfi {
  NativeLibrary _nativeLibrary;

  ArchiverFfi() {
    final _dylib = DynamicLibrary.open(path.join(Directory.current.path,
        'native', 'archiver_lib', AppFiles.ARCHIVER_FFI_LIB));
    //final _dylib = DynamicLibrary.open(AppFiles.ARCHIVER_FFI_LIB); //todo

    _nativeLibrary = NativeLibrary(_dylib);
  }

  Future<void> run() async {
    _nativeLibrary.InitializeDartApi(NativeApi.initializeApiDLData);

    final interactiveCppRequests = ReceivePort();

    final interactiveCppSub = interactiveCppRequests.listen((data) {
      print('Received: ${data} from Go');
    });

    final nativePort = interactiveCppRequests.sendPort.nativePort;

    _nativeLibrary.StartWork(nativePort);

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
