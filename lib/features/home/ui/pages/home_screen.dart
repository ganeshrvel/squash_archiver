import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:archiver_ffi/archiver_ffi.dart';

final helloWorldProvider = Provider((_) => 'Hello world');

class HomeScreen extends HookWidget {
  final String routeName;
  final Object routeArgs;

  const HomeScreen({
    this.routeName,
    this.routeArgs,
  });

  //todo move this to main.dart
  ArchiverFfi get _archiverFfi => getIt<ArchiverFfi>();

  void init() {}

  Future<void> fetchApis() async {
    Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final value = useProvider(helloWorldProvider);

    return Scaffold(
      body: SafeArea(
        top: true,
        child: Center(
          child: Text(value),
        ),
        // child: Center(
        //   child: CustomScrollView(
        //     physics: const ScrollPhysics(),
        //     slivers: <Widget>[
        //       HomeToolbar(),
        //     ],
        //   ), /*Button(
        //     onPressed: () {
        //       _archiverFfi.getWorkData();
        //       _archiverFfi.getUserData();
        //     },
        //     text: 'FFI',
        //   ),*/
        // ),
      ),
    );
  }
}
