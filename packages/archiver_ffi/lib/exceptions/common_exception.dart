class CommonException implements Exception {
  final String error;

  CommonException(this.error);

  @override
  String toString() {
    return error;
  }
}
