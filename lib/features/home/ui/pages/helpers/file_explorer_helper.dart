import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

bool isSupportedArchiveFormat(String format) {
  if (isNullOrEmpty(format)) {
    return false;
  }

  final _supportedExtensions = AppDefaultValues.SUPPORTED_ARCHIVE_EXTENSIONS;

  return _supportedExtensions.contains(format);
}
