import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/common/helpers/archive_helper.dart';
import 'package:squash_archiver/common/models/truncated_string.dart';
import 'package:squash_archiver/utils/utils/date.dart';
import 'package:squash_archiver/utils/utils/filesizes.dart';
import 'package:squash_archiver/utils/utils/hash.dart';
import 'package:squash_archiver/utils/utils/strings.dart';

class FileListingResponse extends Equatable {
  /// file information object
  final FileInfo file;

  const FileListingResponse({
    @required this.file,
  }) : assert(file != null);

  /// if [isSupported] is true then the archive format is supported by the app
  bool get isSupported => isArchiveFormatSupported(file.extension);

  /// human readable string representing the file size
  String get prettyFileSize => !file.isDir ? filesize(file.size) : '';

  /// human readable string representing the date
  String get prettyDate => appDateFormatFromString(file.modTime);

  /// Truncated filename
  TruncatedString get truncatedFilename => truncatedString(text: file.name);

  /// Unique id to be used as a map key.
  /// This is basically md5 hash of the file's fullPath
  String get uniqueId => getMd5(file.fullPath);

  @override
  List<Object> get props => [
        file,
        isSupported,
        prettyFileSize,
        prettyDate,
        truncatedFilename,
        uniqueId,
      ];
}
