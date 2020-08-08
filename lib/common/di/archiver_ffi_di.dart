import 'package:injectable/injectable.dart';
import 'package:archiver_ffi/archiver_ffi.dart';

@module
abstract class ArchiverFfiDi {
  @lazySingleton
  ArchiverFfi get dio => ArchiverFfi();
}
