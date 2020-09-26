import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:archiver_ffi/models/list_archives_request.dart';
import 'package:archiver_ffi/utils/test_utils.dart';

Future<void> main() async {
  final stopwatch = Stopwatch()..start();
  final _archiverFfi = ArchiverFfi(isTest: true);

  final _param = ListArchiveRequest(
      filename: getTestMocksAsset('mock_test_file1.zip'),
      recursive: true,
      listDirectoryPath: '',
      gitIgnorePattern: []);

  final _result = await _archiverFfi.listArchive(_param);

  print(_result.error);
  print(_result.data.files);

  stopwatch.stop();
  print('executed in ${stopwatch.elapsed.inMilliseconds} ms');
}
