import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

T readProvider<T>(BuildContext context) {
  return context.read<T>();
}
