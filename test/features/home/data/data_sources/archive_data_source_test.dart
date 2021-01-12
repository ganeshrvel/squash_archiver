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
  'mock_dir1/2/',
  'mock_dir1/2/b.txt',
  'mock_dir1/3/',
  'mock_dir1/3/2/',
  'mock_dir1/3/2/b.txt',
  'mock_dir1/3/b.txt',
  'mock_dir1/a.txt'
];

const _nonCachedElapsedTime = 7;
const _cachedElapsedTime = 3;

int _testListArchiveCacheResultResetCount = 0;

// check for the execution time to confirm that results were fetched from the cache
void _expectCachedResults({@required int listArchiveCacheResultResetCount}) {
  expect(
    _testListArchiveCacheResultResetCount,
    equals(listArchiveCacheResultResetCount),
  );
}

// check for the execution time to confirm that the results were NOT fetched from the cache
void _expectNonCachedResults({@required int listArchiveCacheResultResetCount}) {
  _testListArchiveCacheResultResetCount =
      _testListArchiveCacheResultResetCount + 1;

  expect(
    _testListArchiveCacheResultResetCount,
    equals(listArchiveCacheResultResetCount),
  );
}

//check if the [cachedListArchiveResult] cache was (re)initialized
void _expectCachedFileList({@required ArchiveDataSource archiveDataSource}) {
  expect(
    archiveDataSource.cachedListArchiveResult.totalFiles,
    equals(10),
  );
  final _fileList = archiveDataSource.cachedListArchiveResult.files
      .map((e) => e.fullPath)
      .toList();
  _fileList.sort((a, b) => a.compareTo(b));

  expect(listEquals(_fileList, _fullFileList), equals(true));
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await getItInit(Environment.test);

  setUpAll(() async {});

  final _archiveDataSource = getIt<ArchiveDataSource>();

  group('ArchiveDataSource', () {
    group('listFiles', () {
      test("listing files in an archive | the cache shouldn't be available",
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache is empty
        expect(_archiveDataSource.cachedListArchiveParams, equals(null));

        // confirm that the [cachedListArchiveResult] cache is empty
        expect(_archiveDataSource.cachedListArchiveResult, equals(null));

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was initialized
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectNonCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'request param remains the same | listing files in an archive | the cache SHOULD be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'modified listDirectoryPath | listing files in an archive | the cache SHOULD be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: 'mock_dir1/',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(listDirectoryPath: '')),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(4));
        expect(_result.data[0].fullPath, equals('mock_dir1/1/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'modified orderBy | listing files in an archive | the cache should be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.fullPath,
          orderDir: OrderDir.none,
          listDirectoryPath: 'mock_dir1/',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(
            orderBy: OrderBy.name,
          )),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(4));
        expect(_result.data[0].fullPath, equals('mock_dir1/1/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        // _expectCachedFileList(archiveDataSource: _archiveDataSource);
        //
        // _expectCachedResults(
        //   listArchiveCacheResultResetCount:
        //       _archiveDataSource.listArchiveCacheResultResetCount,
        // );
      });

      test(
          'modified orderDir | listing files in an archive | the cache should be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.fullPath,
          orderDir: OrderDir.desc,
          listDirectoryPath: 'mock_dir1/',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(
            orderDir: OrderDir.none,
          )),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(4));
        expect(_result.data[0].fullPath, equals('mock_dir1/3/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'modified gitIgnorePattern | listing files in an archive | the cache should NOT be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.fullPath,
          orderDir: OrderDir.desc,
          listDirectoryPath: 'mock_dir1/',
          gitIgnorePattern: const ['fake.txt'],
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(
            gitIgnorePattern: const [],
          )),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(4));
        expect(_result.data[0].fullPath, equals('mock_dir1/3/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectNonCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'reset gitIgnorePattern | listing files in an archive | the cache should NOT be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.fullPath,
          orderDir: OrderDir.desc,
          listDirectoryPath: 'mock_dir1/',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(
            gitIgnorePattern: const ['fake.txt'],
          )),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(4));
        expect(_result.data[0].fullPath, equals('mock_dir1/3/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectNonCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'repeating the same request param | listing files in an archive | the cache SHOULD be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.fullPath,
          orderDir: OrderDir.desc,
          listDirectoryPath: 'mock_dir1/',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(4));
        expect(_result.data[0].fullPath, equals('mock_dir1/3/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(listDirectoryPath: 'mock_dir1/')),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'modified listDirectoryPath | listing files in an archive | the cache SHOULD be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.fullPath,
          orderDir: OrderDir.desc,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(listDirectoryPath: 'mock_dir1/')),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'triggering an error | listing files in an archive | the cache should NOT be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_enc_test_file1.zip'),
          password: '',
          orderBy: OrderBy.fullPath,
          orderDir: OrderDir.desc,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(
            filename: getTestMocksAsset('mock_test_file1.zip'),
          )),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(true));
        expect(_result.hasData, equals(false));

        expect(_result.data?.length ?? 0, equals(0));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(_archiveDataSource.cachedListArchiveParams, equals(null));

        _expectNonCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test("valid request | the cache shouldn't be available", () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_enc_test_file1.zip'),
          password: '1234567',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache is empty
        expect(_archiveDataSource.cachedListArchiveParams, equals(null));

        // confirm that the [cachedListArchiveResult] cache is empty
        expect(_archiveDataSource.cachedListArchiveResult, equals(null));

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was initialized
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectNonCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'modifying filename | listing files in an archive | the cache should NOT be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: '',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(
            filename: getTestMocksAsset('mock_enc_test_file1.zip'),
            password: '1234567',
          )),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectNonCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'modifying password | listing files in an archive | the cache should NOT be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: 'fakepassword',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request.copyWith(
            password: '',
          )),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectNonCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'invalidating the cache | listing files in an archive | the cache should NOT be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: 'fakepassword',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
          invalidateCache: true,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data?.length ?? 0, equals(1));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(_archiveDataSource.cachedListArchiveParams, equals(_request));

        _expectNonCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });

      test(
          'modified listDirectoryPath | listing files in an archive | the cache SHOULD be used',
          () async {
        final _request = ListArchive(
          filename: getTestMocksAsset('mock_test_file1.zip'),
          password: 'fakepassword',
          orderBy: OrderBy.name,
          orderDir: OrderDir.none,
          listDirectoryPath: '',
        );

        // confirm that the [cachedListArchiveParams] cache exists
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        final _result = await _archiveDataSource.listFiles(
          listArchiveRequest: _request,
        );

        expect(_result.hasError, equals(false));
        expect(_result.hasData, equals(true));

        expect(_result.data.length, equals(1));
        expect(_result.data[0].fullPath, equals('mock_dir1/'));

        //check if the [cachedListArchiveParams] cache was reinitialized
        expect(
          _archiveDataSource.cachedListArchiveParams,
          equals(_request),
        );

        _expectCachedFileList(archiveDataSource: _archiveDataSource);

        _expectCachedResults(
          listArchiveCacheResultResetCount:
              _archiveDataSource.listArchiveCacheResultResetCount,
        );
      });
    });
  });
}
