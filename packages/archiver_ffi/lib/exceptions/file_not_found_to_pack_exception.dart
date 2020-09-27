class FileNotFoundToPackException implements Exception {
  final String error;

  FileNotFoundToPackException(this.error);

  @override
  String toString() {
    return error;
  }
}
