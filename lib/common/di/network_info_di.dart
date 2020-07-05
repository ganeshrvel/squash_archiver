import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkInfoDi {
  @lazySingleton
  DataConnectionChecker get dataConnectionChecker => DataConnectionChecker();
}
