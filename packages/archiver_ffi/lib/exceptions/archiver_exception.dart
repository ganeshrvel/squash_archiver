class ArchiverException implements Exception {
  final String error;

  ArchiverException(this.error);

  @override
  String toString() {
    return error;
  }
}
