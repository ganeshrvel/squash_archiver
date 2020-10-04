class TaskInProgressException implements Exception {
  final String error;

  TaskInProgressException({
    this.error = 'A similar task is already in progress',
  });

  @override
  String toString() {
    return error;
  }
}
