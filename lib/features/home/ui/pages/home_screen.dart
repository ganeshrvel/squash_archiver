import 'package:flutter/material.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/helpers/navigation_helper.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/ffi/archiver_ffi/archiver_ffi.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends SfWidget<HomeScreen> {
  List<ReactionDisposer> _disposers;

  ArchiverFfi get _archiverFfi => getIt<ArchiverFfi>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _disposers ??= [];
  }

  // this is set when the first time the app is loaded
  // but it keeps calling methods inside everytime the widget refreshes
  // it is a bad to call apis as it might keep fetching the apis unnecessarily
  // use this to initialize things like store and make sure that '??=' operator is used while initializing
  @override
  void initState() {
    init();

    super.initState();
  }

  // this is called only once when the store is loaded.
  // add the api fetch calls in here
  @override
  void onInitApp() {
    // wrap [fetchApis] in [isCurrentScreen] to avoid multiple data fetches since this is also the root route
    // the splash screen might cause multiple fetch api call.
    if (isCurrentScreen(context)) {
      fetchApis();
    }

    super.onInitApp();
  }

  void init() {}

  Future<void> fetchApis() async {
    Future.value();
  }

  @override
  void dispose() {
    if (_disposers != null) {
      for (final d in _disposers) {
        d();
      }
    }

    super.dispose();
  }

  void _testFfi() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Center(
          child: Button(
            onPressed: () {
              _archiverFfi.run();
            },
            text: 'FFI',
          ),
        ), /*CustomScrollView(
          physics: const ScrollPhysics(),
          slivers: <Widget>[
            HomeToolbar(),
          ],
        )*/
      ),
    );
  }
}
