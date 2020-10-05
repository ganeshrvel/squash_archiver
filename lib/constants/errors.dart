class Errors {
  Errors._();

  static const String INTERNAL_SERVER_MESSAGE = 'Server failure encountered';

  static const String CACHE_FAILURE_MESSAGE =
      'Local storage failure encountered';

  static const String DIO_EXCEPTION_MESSAGE =
      'Something went wrong while connecting to our servers';

  static const String INVALID_UNAUTHENTICATED_MESSAGE =
      'Something went wrong while authenticating your account. Try signing in back again.';

  static const String BAD_NETWORK_MESSAGE =
      'Internet connectivity is not available.';

  static const String NETWORK_404_MESSAGE = DIO_EXCEPTION_MESSAGE;

  static const String UNKNOWN_FAILURE_MESSAGE = 'Some unknown error occured';

  static const String INACCESSIBLE_ROUTE_MESSAGE =
      'The route is inaccessible. Please login first';

  static const String INVALID_OTP_AUTHENTICATION_MESSAGE = 'Invalid OTP';

  static const String TASK_IN_PROGRESS_MESSAGE = 'A similar task is already in progress';
}
