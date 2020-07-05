import 'package:meta/meta.dart';

class Network404Exception implements Exception {
  final String errorMessage;
  final String apiUrl;
  final StackTrace stackTrace;

  Network404Exception({
    @required this.errorMessage,
    @required this.apiUrl,
    @required this.stackTrace,
  });

  @override
  String toString() {
    return 'errorMessage: $errorMessage, API URI: $apiUrl';
  }
}
