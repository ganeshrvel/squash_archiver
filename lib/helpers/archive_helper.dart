import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

bool isArchiveFormatSupported(String ext) {
  if (isNullOrEmpty(ext)) {
    return false;
  }

  const _supportedExtensions = AppDefaultValues.SUPPORTED_ARCHIVE_EXTENSIONS;

  return isNotNull(_supportedExtensions[ext]);
}
