class FilterPathNotFoundException implements Exception {
  final String error;

  FilterPathNotFoundException(this.error);

  @override
  String toString() {
    return error;
  }
}
