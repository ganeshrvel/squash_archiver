import 'package:archiver_ffi/models/file_info.dart';
import 'package:hooks_riverpod/all.dart';

class ListArchiveNotifier extends StateNotifier<List<FileInfo>> {
  ListArchiveNotifier(List<FileInfo> state) : super(state);

  void add(List<FileInfo> _list) {
    state = _list;
  }
}

final listArchiveProvider = StateNotifierProvider<ListArchiveNotifier>(
  (ref) => ListArchiveNotifier([]),
);
