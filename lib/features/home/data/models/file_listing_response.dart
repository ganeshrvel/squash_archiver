import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:equatable/equatable.dart';

import 'package:squash_archiver/helpers/archive_helper.dart';
import 'package:squash_archiver/utils/utils/date.dart';
import 'package:squash_archiver/utils/utils/filesizes.dart';

class FileListingResponse extends Equatable {
  /// file index
  final int index;

  /// Unique id to be used as a map key.
  /// This is basically a unique hash of the file's fullPath
  final String uniqueId;

  /// file information object
  final FileInfo file;

  const FileListingResponse({
    required this.index,
    required this.uniqueId,
    required this.file,
  });

  /// if [isArchiveSupported] is true then the archive format is supported by the app
  bool get isArchiveSupported => isArchiveFormatSupported(file.extension);

  /// human readable string representing the file size
  String get prettyFileSize => !file.isDir ? filesize(file.size) : '';

  /// human readable string representing the date
  String get prettyDate => appDateFormatFromString(file.modTime);

  String get kind => file.kind;

  @override
  List<Object> get props => [
        file,
        isArchiveSupported,
        prettyFileSize,
        prettyDate,
        uniqueId,
        index,
        kind,
      ];
}
