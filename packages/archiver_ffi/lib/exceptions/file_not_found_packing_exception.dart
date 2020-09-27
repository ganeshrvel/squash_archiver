class FileNotFoundPackingException implements Exception {
  final String error;

  FileNotFoundPackingException(this.error);

  @override
  String toString() {
    return error;
  }
}
