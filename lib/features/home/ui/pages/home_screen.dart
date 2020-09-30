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

    final stopwatch = Stopwatch()..start();

    final _files = await _archiver.listFiles(_testFile);

    if (_files.hasError) {
      //todo add error exception for operation not permitted
      print(_files.error);

      return;
    }

    stopwatch.stop();
    print('executed in ${stopwatch.elapsed.inMilliseconds} ms');

    context.read(listArchiveProvider).add(_files.data.files);
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
