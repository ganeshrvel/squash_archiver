import 'package:equatable/equatable.dart';

class TruncatedString extends Equatable {
  final String original;
  final String firstChunk;
  final String lastChunk;

  const TruncatedString({
    required this.original,
    required this.firstChunk,
    required this.lastChunk,
  });

  @override
  List<Object> get props => [
        original,
        firstChunk,
        lastChunk,
      ];
}
