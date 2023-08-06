import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:xxh3/xxh3.dart';

String getMd5(String x) {
  return md5.convert(utf8.encode(x)).toString();
}

int getXxh3(String x) {
  final bytes = utf8.encode(x);

  return xxh3(Uint8List.fromList(bytes));
}
