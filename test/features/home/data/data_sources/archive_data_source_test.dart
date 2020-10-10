import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/features/home/data/data_sources/archive_data_source.dart';


Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.setMockInitialValues({});

  await getItInit(Environment.test);

  final _repo = getIt<ArchiveDataSource>();

  // setUpAll(() async {
  //
  // });

  group('ArchiveDataSource', () {
    group('listFiles', () {
      test('DEFAULT_FILE_EXPLORER_DIRECTORY', () {
        /*final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
        );
        _archiveDataSource.listFiles(listArchiveRequest: _request);*/

        // final _request = ListArchive(filename: '');

        //print(getTestMocksAsset('mock_test_file1.zip'));

        /*_ffiLib.listArchive(params);

        expect(
          AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
          equals(homeDirectory()),
        );*/
      });
    });
  });
}
