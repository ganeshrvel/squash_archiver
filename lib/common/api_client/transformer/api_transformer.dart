import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Not used anymore
class ApiTransformer extends DefaultTransformer {
  ApiTransformer() : super(jsonDecodeCallback: _parseJson);
}

// Must be top-level function
dynamic _parseAndDecode(String response) {
  final jsonDecoded = json.decode(response);

  var _dataObj = {};

  if (jsonDecoded['data'] != null) {
    _dataObj = jsonDecoded['data'] as Map<String, dynamic>;
  }

  return {
    ..._dataObj,
    'error': jsonDecoded['error'],
    'success': jsonDecoded['success'],
  }.cast<String, dynamic>();
}

Future _parseJson(String text) {
  return compute(_parseAndDecode, text);
}
