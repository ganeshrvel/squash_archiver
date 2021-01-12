import 'dart:async';

import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/home/data/enums/file_explorer_source.dart';
import 'package:squash_archiver/features/home/ui/pages/file_explorer_screen_store.dart';

import '../../../../support/test_utils.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await getItInit(Environment.test);

  setUpAll(() async {});

  final _fileExplorerScreenStore = FileExplorerScreenStore();

  group('FileExplorerScreenStore', () {
    test('setting a new local source', () async {
      expect(
        _fileExplorerScreenStore.fileListingSourceStack.length,
        equals(0),
      );

      _fileExplorerScreenStore.navigateToSource(
        fullPath: AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY,
        source: FileExplorerSource.LOCAL,
        clearStack: true,
      );

      expect(
        _fileExplorerScreenStore.currentPath,
        equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_DIRECTORY),
      );

      expect(
        _fileExplorerScreenStore.source,
        equals(FileExplorerSource.LOCAL),
      );

      expect(
        _fileExplorerScreenStore.orderBy,
        equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY),
      );

      expect(
        _fileExplorerScreenStore.orderDir,
        equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR),
      );

      expect(
        _fileExplorerScreenStore.fileListingSourceStack.length,
        equals(1),
      );
    });
  });

  test('setting a new archive source', () async {
    _fileExplorerScreenStore.navigateToSource(
      fullPath: '/',
      source: FileExplorerSource.ARCHIVE,
      clearStack: false,
      currentArchiveFilepath: getTestMocksAsset('mock_test_file1.zip'),
    );

    expect(
      _fileExplorerScreenStore.currentPath,
      equals('/'),
    );

    expect(
      _fileExplorerScreenStore.source,
      equals(FileExplorerSource.ARCHIVE),
    );

    expect(
      _fileExplorerScreenStore.orderBy,
      equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY),
    );

    expect(
      _fileExplorerScreenStore.orderDir,
      equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR),
    );

    expect(
      _fileExplorerScreenStore.fileListingSourceStack.length,
      equals(2),
    );
  });

  test('changing the current path', () async {
    _fileExplorerScreenStore.setCurrentPath('mock_dir1/');

    expect(
      _fileExplorerScreenStore.currentPath,
      equals('mock_dir1/'),
    );

    expect(
      _fileExplorerScreenStore.source,
      equals(FileExplorerSource.ARCHIVE),
    );

    expect(
      _fileExplorerScreenStore.orderBy,
      equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY),
    );

    expect(
      _fileExplorerScreenStore.orderDir,
      equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR),
    );

    expect(
      _fileExplorerScreenStore.fileListingSourceStack.length,
      equals(2),
    );

    /// to next directory

    _fileExplorerScreenStore.setCurrentPath('1');

    expect(
      _fileExplorerScreenStore.currentPath,
      equals('1'),
    );

    expect(
      _fileExplorerScreenStore.source,
      equals(FileExplorerSource.ARCHIVE),
    );

    expect(
      _fileExplorerScreenStore.orderBy,
      equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_BY),
    );

    expect(
      _fileExplorerScreenStore.orderDir,
      equals(AppDefaultValues.DEFAULT_FILE_EXPLORER_ORDER_DIR),
    );

    expect(
      _fileExplorerScreenStore.fileListingSourceStack.length,
      equals(2),
    );
  });

  test('changing the orderDir and orderBy', () async {
    _fileExplorerScreenStore.setOrderDirOrderBy(
        orderDir: OrderDir.desc, orderBy: OrderBy.size);

    expect(
      _fileExplorerScreenStore.currentPath,
      equals('1'),
    );

    expect(
      _fileExplorerScreenStore.source,
      equals(FileExplorerSource.ARCHIVE),
    );

    expect(
      _fileExplorerScreenStore.orderBy,
      equals(OrderBy.size),
    );

    expect(
      _fileExplorerScreenStore.orderDir,
      equals(OrderDir.desc),
    );

    expect(
      _fileExplorerScreenStore.fileListingSourceStack.length,
      equals(2),
    );
  });
}
