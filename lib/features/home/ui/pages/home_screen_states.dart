import 'package:archiver_ffi/models/archive_file_info.dart';
import 'package:hooks_riverpod/all.dart';

class ListArchiveNotifier extends StateNotifier<List<ArchiveFileInfo>> {
  ListArchiveNotifier(List<ArchiveFileInfo> state) : super(state);

  void add(List<ArchiveFileInfo> _list) {
    state = _list;
  }
}

final listArchiveProvider = StateNotifierProvider<ListArchiveNotifier>(
  (ref) => ListArchiveNotifier([]),
);
