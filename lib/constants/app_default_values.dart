import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:squash_archiver/utils/utils/files.dart';

class AppDefaultValues {
  AppDefaultValues._();

  static final String DEFAULT_FILE_EXPLORER_DIRECTORY = homeDirectory();

  static const OrderBy DEFAULT_FILE_EXPLORER_ORDER_BY = OrderBy.fullPath;

  static const OrderDir DEFAULT_FILE_EXPLORER_ORDER_DIR = OrderDir.none;

  static const List<String> SUPPORTED_ARCHIVE_EXTENSIONS = [
    'zip',
    'rar'
  ];
}
