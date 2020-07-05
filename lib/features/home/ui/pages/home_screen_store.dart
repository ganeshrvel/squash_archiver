import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'home_screen_store.g.dart';

@lazySingleton
class HomeScreenStore = _HomeScreenStoreBase with _$HomeScreenStore;

abstract class _HomeScreenStoreBase with Store {}
