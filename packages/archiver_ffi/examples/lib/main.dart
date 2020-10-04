import 'package:archiver_ffi/src/archiver_ffi.dart';
import 'package:archiver_ffi/src/models/is_archive_encrypted.dart';
import 'package:archiver_ffi/src/models/list_archive.dart';
import 'package:archiver_ffi/src/models/pack_files.dart';
import 'package:archiver_ffi/src/models/unpack_files.dart';
import 'package:archiver_ffi/src/utils/test_utils.dart';
import 'package:meta/meta.dart';

Future<void> main() async {
  _listArchive();
  _isArchiveEncrypted();
  _packFiles();
  _unpackFiles();
}

Future<void> _listArchive() async {
  final _archiverFfi = ArchiverFfi(isTest: true);
  final stopwatch = Stopwatch()..start();

  final _param = ListArchive(
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

Future<void> _isArchiveEncrypted() async {
  final _archiverFfi = ArchiverFfi(isTest: true);

  final stopwatch = Stopwatch()..start();

  final _param = IsArchiveEncrypted(
    filename: getTestMocksAsset('mock_enc_test_file1.zip'),
  );

  final _result = await _archiverFfi.isArchiveEncrypted(_param);

  print(_result.error);
  print(_result.data.isEncrypted);

  stopwatch.stop();
  print('executed in ${stopwatch.elapsed.inMilliseconds} ms');
}

void _packingCb({
  @required String startTime,
  @required String currentFilename,
  @required int totalFiles,
  @required int progressCount,
  @required double progressPercentage,
}) {
  print(progressPercentage);
}

Future<void> _unpackFiles() async {
  final _archiverFfi = ArchiverFfi(isTest: true);
  final stopwatch = Stopwatch()..start();

  final _param = UnpackFiles(
    filename: getTestMocksAsset('mock_test_file1.zip'),
    password: '',
    destination: getTestMocksBuildAsset('mock_test_file1'),
    gitIgnorePattern: [],
    fileList: [],
  );

  final _result = await _archiverFfi.unpackFiles(
    _param,
    onProgress: _packingCb,
  );

  print(_result.error);
  print(_result.data.success);

  stopwatch.stop();
  print('executed in ${stopwatch.elapsed.inMilliseconds} ms');
}

Future<void> _packFiles() async {
  final _archiverFfi = ArchiverFfi(isTest: true);
  final stopwatch = Stopwatch()..start();

  final _param = PackFiles(
    filename: getTestMocksBuildAsset('mock_test_file1.zip'),
    password: '',
    gitIgnorePattern: [],
    fileList: [getTestMocksAsset('mock_dir1')],
  );

  final _result = await _archiverFfi.packFiles(
    _param,
    onProgress: _packingCb,
  );

  print(_result.error);
  print(_result.data.success);

  stopwatch.stop();
  print('executed in ${stopwatch.elapsed.inMilliseconds} ms');
}
