import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

T readProvider<T>(BuildContext context) {
  return context.read<T>();
}
