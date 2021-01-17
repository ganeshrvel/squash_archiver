import 'package:meta/meta.dart';
import 'package:squash_archiver/common/models/truncated_filename.dart';

String enumToString(dynamic input) {
  return input.toString().split('.').last;
}

String enumToStringSingle(dynamic input) {
  return enumToString(input).split(RegExp('[A-Z]')).first;
}

T stringToEnum<T>(String input, List<T> values) {
  return values.firstWhere((e) => input == enumToString(e), orElse: () => null);
}

bool isBlank(String input) {
  return input.trim().isEmpty;
}

String capitalize(String input) {
  return input[0].toUpperCase() + input.substring(1);
}

String plural({String text, int value}) {
  if (value == 1) {
    return text;
  } else {
    return '$value ${text}s';
  }
}

bool isAlphaSpace(String value) {
  return RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
}

// Checks whether the given string [input] is a valid URL
bool isUrl(String input) {
  const regex =
      r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})';

  final regExp = RegExp(regex);

  return regExp.hasMatch(input);
}

/// returns truncated string
/// [offset] minimum number of chars to be displayed in the last chunk
/// [offset] is exclusive of extension
TruncatedFilename truncatedString({@required String text, int offset}) {
  assert(text != null);

  final _offset = offset ?? 6;
  assert(_offset >= 0);

  final _length = text.length;

  /// last chunk will contain extension(if any) + chars of offset length
  final _lastChunkLength = _offset;
  var _firstChunkLength = 0;

  if (_length - _lastChunkLength > 0) {
    _firstChunkLength = _length - _lastChunkLength;
  }

  // first chunk will contain chars starting from beginning to lastChunkLength
  final _firstChunk = text.substring(0, _firstChunkLength);
  final _lastChunk = text.substring(_firstChunkLength, _length);

  return TruncatedFilename(
    original: text,
    firstChunk: _firstChunk,
    lastChunk: _lastChunk,
  );
}
