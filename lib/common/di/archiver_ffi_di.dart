import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ArchiverFfiDi {
  @lazySingleton
  ArchiverFfi get archiverFfi => ArchiverFfi();
}
