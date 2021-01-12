import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_entities_sort_by.dart';
import 'package:squash_archiver/utils/utils/files.dart';

class AppDefaultValues {
  AppDefaultValues._();

  static const String DEFAULT_DATE_TIME_FORMAT = 'yyyy-MM-dd H:m:s';

  static final String DEFAULT_FILE_EXPLORER_DIRECTORY = homeDirectory();

  static const OrderBy DEFAULT_FILE_EXPLORER_ORDER_BY = OrderBy.name;

  static const OrderDir DEFAULT_FILE_EXPLORER_ORDER_DIR = OrderDir.asc;

  static const FileExplorerEntitiesSortBy
      DEFAULT_FILE_EXPLORER_ENTITIES_SORT_BY =
      FileExplorerEntitiesSortBy.directory;

  static const bool SHOW_HIDDEN_FILES = false; //todo move this into a setting

  static const Set<String> SUPPORTED_ARCHIVE_EXTENSIONS = {
    'zip',
    'tar',
    'tar.br',
    'tar.bz2',
    'tar.gz',
    'tar.lz4',
    'tar.sz',
    'tar.xz',
    'tar.zst',
    'rar',
  };

  static const ALLOWED_SECOND_EXTENSIONS = {
    'tar',
  };
}
