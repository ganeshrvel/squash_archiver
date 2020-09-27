class InvalidPasswordException implements Exception {
  final String error;

  InvalidPasswordException(this.error);

  @override
  String toString() {
    return error;
  }
}
