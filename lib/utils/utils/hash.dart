import 'dart:convert';
import 'package:crypto/crypto.dart';

String getMd5(String x) {
  return md5.convert(utf8.encode(x)).toString();
}
