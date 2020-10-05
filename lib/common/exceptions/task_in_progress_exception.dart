import 'package:squash_archiver/constants/errors.dart';

class TaskInProgressException implements Exception {
  final String error;

  TaskInProgressException({
    this.error = Errors.TASK_IN_PROGRESS_MESSAGE,
  });

  @override
  String toString() {
    return error;
  }
}
