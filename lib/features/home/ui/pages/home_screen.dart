import 'package:archiver_ffi/models/list_archive.dart';
import 'package:archiver_ffi/structs/list_archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/features/home/ui/pages/home_screen_states.dart';
import 'package:squash_archiver/utils/archiver/archiver.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/widgets/button/button.dart';

final _currentHelloWorld = ScopedProvider<String>(null);

class HomeScreen extends HookWidget {
  final String routeName;
  final Object routeArgs;

  const HomeScreen({
    this.routeName,
    this.routeArgs,
  });

  Archiver get _archiver => getIt<Archiver>();

  Future<void> _listFiles(BuildContext context) async {
    final _testFile = getDesktopFile('squash-test-assets/huge_file.zip');
    //final _testFile = getDesktopFile('squash-test-assets/mock_test_file1.zip');

    final stopwatch = Stopwatch()..start();

    final _files = await _archiver.listFiles(ListArchive(
      filename: _testFile,
      recursive: true,
      listDirectoryPath: 'flutter/dev/benchmarks/',
      orderBy: OrderBy.fullPath,
      orderDir: OrderDir.asc,
    ));

    if (_files.hasError) {
      //todo add error exception for operation not permitted
      print(_files.error);

      return;
    }

    _files.data.forEach((element) {
      print(element.fullPath);
    });

    print(_files.data.length);

    stopwatch.stop();
    print('executed in ${stopwatch.elapsed.inMilliseconds} ms');

    context.read(listArchiveProvider).add(_files.data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              // HomeToolbar(),
              const SizedBox(
                height: 30,
              ),
              // for (final file in _listArchiveProviderValue)
              //   Column(
              //     children: [
              //       // Textography(file.name),
              //     ],
              //   ),
              const SizedBox(
                height: 30,
              ),
              Button(
                onPressed: () {
                  _listFiles(context);
                },
                text: 'FFI',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
