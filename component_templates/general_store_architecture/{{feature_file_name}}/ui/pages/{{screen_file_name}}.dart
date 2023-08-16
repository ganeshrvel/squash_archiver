import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:squash_archiver/utils/utils/store_helper.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:mobx/mobx.dart';

class {{ScreenClassName}} extends StatefulWidget {
  const {{ScreenClassName}}({super.key});

  @override
  State<StatefulWidget> createState() => _{{ScreenClassName}}State();
}

class _{{ScreenClassName}}State extends SfWidget<{{ScreenClassName}}> {
	late final {{ScreenClassName}}Store _{{screenClassNameLower}}Store = {{ScreenClassName}}Store();

  late List<ReactionDisposer> _disposers;

	@override
	void didChangeDependencies() {
	  super.didChangeDependencies();

	  _disposers ??= [
		reaction(
				(_) => _{{screenClassNameLower}}Store.{{mobxParam}}Exception,
				(Exception exception) {
					throwException(context, exception);
				},
		),
	  ];
	}

	@override
	void initState() {
	  _init();

	  super.initState();
	}

  // this is called only once after the first frame of the widget is painted
  @override
  void onInitApp() {
    super.onInitApp();
  }

  @override
  void dispose() {
    disposeStore(_disposers);

    super.dispose();
  }

  void _init() {
    _fetchApi();
  }

  Future<void> _fetchApi({int pageNumber}) async {
    final _pageNumber = pageNumber ?? 1;

    final _params = {{ModelClassName}}Request(
      page: _pageNumber,
    );

    return _{{screenClassNameLower}}Store.{{methodName}}(_params);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        final _{{mobxParam}}Future =
            _{{screenClassNameLower}}Store.{{mobxParam}}Future;
        final _{{mobxParam}} =
            _{{screenClassNameLower}}Store?.{{mobxParam}};
        final _is{{MobxParamUpper}}Loaded =
            isNotNull(_{{mobxParam}});
        final _skipShimmer = isNotNull(_{{mobxParam}});

        return Container();
      },
    );
  }
}
