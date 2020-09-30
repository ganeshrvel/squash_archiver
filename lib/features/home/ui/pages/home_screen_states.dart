import 'package:archiver_ffi/models/archive_file_info.dart';
import 'package:archiver_ffi/models/list_archive.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/utils/archiver/archiver.dart';
import 'package:squash_archiver/utils/utils/files.dart';

final _archiver = getIt<Archiver>();

// current path in the file explorer
class CurrentPathNotifier extends StateNotifier<String> {
  CurrentPathNotifier(String state) : super(state);

  void setPath(String value) {
    state = value;
  }

  void prevPath() {
    state = getParentPath(state);
  }
}

final currentPathProvider = StateNotifierProvider<CurrentPathNotifier>(
  (ref) => CurrentPathNotifier(''),
);

///
///
///
/// current archive file in the explorer
///
///
///
class CurrentArchivePathNotifier extends StateNotifier<String> {
  CurrentArchivePathNotifier(String state) : super(state);

  void setPath(String value) {
    state = value;
  }
}

final currentArchivePathProvider =
    StateNotifierProvider<CurrentArchivePathNotifier>((ref) {
  final _testFile = getDesktopFile('squash-test-assets/huge_file.zip');

  return CurrentArchivePathNotifier(_testFile);
});

// files in the current file explorer screen

final fileListProvider = FutureProvider<List<ArchiveFileInfo>>((ref) async {
  final _filename = ref.watch(currentArchivePathProvider.state);
  final _currentPath = ref.watch(currentPathProvider.state);

  final _params = ListArchive(
    filename: _filename,
    listDirectoryPath: _currentPath,
    recursive: true,
  );

  final _result = await _archiver.listFiles(_params);

  if (_result.hasError) {
    print('Oops error occured...');
    print(_result.error.error);

    return [];
  }

  return _result.data;
});
