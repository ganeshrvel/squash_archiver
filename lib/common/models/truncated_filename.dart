import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TruncatedFilename extends Equatable {
  final String original;
  final String firstChunk;
  final String lastChunk;

  const TruncatedFilename({
    @required this.original,
    @required this.firstChunk,
    @required this.lastChunk,
  });

  @override
  List<Object> get props => [
        original,
        firstChunk,
        lastChunk,
      ];
}
