import 'dart:async';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/features/home/data/data_sources/archive_data_source.dart';

import '../../../../support/test_utils.dart';

final _fullFileList = [
  'mock_dir1/',
  'mock_dir1/1/',
  'mock_dir1/1/a.txt',
  'mock_dir1/a.txt',
  'mock_dir1/3/',
  'mock_dir1/3/b.txt',
  'mock_dir1/3/2/',
  'mock_dir1/3/2/b.txt',
  'mock_dir1/2/',
  'mock_dir1/2/b.txt',
];

const _nonCachedElapsedTime = 7;
const _cachedElapsedTime = 3;

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await getItInit(Environment.test);

  setUpAll(() async {});

  final _archiveDataSource = getIt<ArchiveDataSource>();

  group('ArchiveDataSource', () {
    group('listFiles', () {
      final filename = getTestMocksAsset('mock_test_file0.zip');
      const password = '';

      test("listing files in an archive | the cache shouldn't be available",
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file0.zip'),
          password: '',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache is empty
        expect(_archiveDataSource.cachedListArchiveParams, equals(null));

        // confirm that the [cachedListArchiveResult] cache is empty
        expect(_archiveDataSource.cachedListArchiveResult, equals(null));

        final stopwatch = Stopwatch()..start();

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        final elapsedTime = stopwatch..stop();

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was initialized
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        //check if the [cachedListArchiveResult] cache was initialized
        expect(
            _archiveDataSource.cachedListArchiveResult.totalFiles, equals(10));
        expect(
            listEquals(
              _archiveDataSource.cachedListArchiveResult.files
                  .map((e) => e.fullPath)
                  .toList(),
              _fullFileList,
            ),
            equals(true));

        // check for the execution time to confirm that results were not fetched from the cache
        expect(elapsedTime.elapsed.inMilliseconds,
            greaterThanOrEqualTo(_nonCachedElapsedTime));
      });

      test('listing files in an archive | the cache SHOULD be available',
          () async {
        final _request = ListArchive(
          filename: filename,
          password: password,
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        // confirm that the [cachedListArchiveResult] cache exists
        expect(
            _archiveDataSource.cachedListArchiveResult.totalFiles, equals(10));
        expect(
            listEquals(
              _archiveDataSource.cachedListArchiveResult.files
                  .map((e) => e.fullPath)
                  .toList(),
              _fullFileList,
            ),
            equals(true));

        final stopwatch = Stopwatch()..start();

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        final elapsedTime = stopwatch..stop();

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was initialized
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        //check if the [cachedListArchiveResult] cache was initialized
        expect(
            _archiveDataSource.cachedListArchiveResult.totalFiles, equals(10));
        expect(
            listEquals(
              _archiveDataSource.cachedListArchiveResult.files
                  .map((e) => e.fullPath)
                  .toList(),
              _fullFileList,
            ),
            equals(true));

        // check for the execution time to confirm that results were not fetched from the cache
        expect(elapsedTime.elapsed.inMilliseconds,
            lessThanOrEqualTo(_cachedElapsedTime));
      });

      /// todo
      test(
          'filtering the files using listDirectoryPath | listing files in an archive | the cache SHOULD be available',
          () async {
        final _request = ListArchive(
          filename: filename,
          password: password,
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        // confirm that the [cachedListArchiveResult] cache exists
        expect(
            _archiveDataSource.cachedListArchiveResult.totalFiles, equals(10));
        expect(
            listEquals(
              _archiveDataSource.cachedListArchiveResult.files
                  .map((e) => e.fullPath)
                  .toList(),
              _fullFileList,
            ),
            equals(true));

        final stopwatch = Stopwatch()..start();

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        final elapsedTime = stopwatch..stop();

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was initialized
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        //check if the [cachedListArchiveResult] cache was initialized
        expect(
            _archiveDataSource.cachedListArchiveResult.totalFiles, equals(10));
        expect(
            listEquals(
              _archiveDataSource.cachedListArchiveResult.files
                  .map((e) => e.fullPath)
                  .toList(),
              _fullFileList,
            ),
            equals(true));

        // check for the execution time to confirm that results were not fetched from the cache
        expect(elapsedTime.elapsed.inMilliseconds,
            lessThanOrEqualTo(_cachedElapsedTime));
      });
    });
  });
}
