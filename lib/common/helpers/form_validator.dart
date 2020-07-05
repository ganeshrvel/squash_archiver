import 'package:squash_archiver/utils/utils/functs.dart';

bool isFormValid(List<String> fieldsErrorTextList) {
  for (final filedErrorValue in fieldsErrorTextList) {
    if (isNotNullOrEmpty(filedErrorValue)) {
      return false;
    }
  }

  return true;
}
