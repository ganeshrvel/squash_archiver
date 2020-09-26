class FileNotFoundException implements Exception {
  final String error;

  FileNotFoundException(this.error);

  @override
  String toString() {
    return error;
  }
}
