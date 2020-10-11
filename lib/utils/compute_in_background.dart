import 'package:flutter/foundation.dart' as flutter
    show compute, ComputeCallback;
import 'package:squash_archiver/constants/env.dart';

/// Isolates spawned using "compute" don't execute properly while executed in an integration test which in turn results in incorrect app behavior.
/// issue: https://github.com/flutter/flutter/issues/24703
/// workaround: https://github.com/flutter/flutter/issues/24703#issuecomment-473335593
Future<R> computeInBackground<Q, R>(
    flutter.ComputeCallback<Q, R> callback, Q message) async {
  if (env.IS_TEST) {
    return callback(message);
  }

  return flutter.compute(callback, message);
}
