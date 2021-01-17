class ArchiverException implements Exception {
  final String error;

  ArchiverException(this.error);

  @override
  String toString() {
    return error;
  }
}

class FileNotFoundException implements ArchiverException {
  @override
  final String error;

  FileNotFoundException(this.error);

  @override
  String toString() {
    return error;
  }
}

class FileNotFoundToPackException implements ArchiverException {
  @override
  final String error;

  FileNotFoundToPackException(this.error);

  @override
  String toString() {
    return error;
  }
}

class UnsupportedFileFormatException implements ArchiverException {
  @override
  final String error;

  UnsupportedFileFormatException(this.error);

  @override
  String toString() {
    return error;
  }
}

class FilterPathNotFoundException implements ArchiverException {
  @override
  final String error;

  FilterPathNotFoundException(this.error);

  @override
  String toString() {
    return error;
  }
}

class PasswordRequiredException implements ArchiverException {
  @override
  final String error;

  PasswordRequiredException(this.error);

  @override
  String toString() {
    return error;
  }
}

class InvalidPasswordException implements ArchiverException {
  @override
  final String error;

  InvalidPasswordException(this.error);

  @override
  String toString() {
    return error;
  }
}

class OperationNotPermittedException implements ArchiverException {
  @override
  final String error;

  OperationNotPermittedException(this.error);

  @override
  String toString() {
    return error;
  }
}
