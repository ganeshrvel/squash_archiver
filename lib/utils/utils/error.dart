import 'package:squash_archiver/utils/utils/functs.dart';

String getErrorBody(Map<String, String> texts) {
  var _errorBody = '\n━━━━━━━━━━━━━━━━━━━━\n';

  texts.forEach((k, v) {
    if (isNullOrEmpty(v)) {
      return;
    }

    _errorBody += '$k: $v';
    _errorBody += '\n━━━━━━━━━━━━━━━━━━━━\n';
  });

  return _errorBody;
}
