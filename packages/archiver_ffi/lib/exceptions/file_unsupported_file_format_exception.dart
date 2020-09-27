class UnsupportedFileFormatException implements Exception {
  final String error;

  UnsupportedFileFormatException(this.error);

  @override
  String toString() {
    return error;
  }
}
