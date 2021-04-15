import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/utils/utils/files.dart';

@module
abstract class ArchiverFfiDi {
  @dev
  @LazySingleton()
  ArchiverFfi get archiverFfi => ArchiverFfi();

  /// for testing [libAbsPath] has to be passed through the constructor of [ArchiverFfi]
  @test
  @LazySingleton()
  ArchiverFfi get archiverFfiTest => ArchiverFfi(libAbsPath: getNativeLib());
}
