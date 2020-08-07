import 'package:injectable/injectable.dart';
import 'package:squash_archiver/ffi/archiver_ffi/archiver_ffi.dart';

@module
abstract class ArchiverFfiDi {
  @lazySingleton
  ArchiverFfi get dio => ArchiverFfi();
}
