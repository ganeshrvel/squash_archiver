import 'package:squash_archiver/constants/service_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry/sentry.dart';

@module
abstract class SentryClientDI {
  @lazySingleton
  SentryClient get sentryClient => SentryClient(dsn: ServiceKeys.SENTRY_DSN);
}
