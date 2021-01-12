import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:squash_archiver/features/home/ui/pages/helpers/file_explorer_helper.dart';
import 'package:squash_archiver/utils/utils/date.dart';
import 'package:squash_archiver/utils/utils/filesizes.dart';

class FileListingResponse extends Equatable {
  /// file information object
  final FileInfo file;

  const FileListingResponse({
    @required this.file,
  }) : assert(file != null);

  /// if [isSupported] is true then the archive format is supported by the app
  bool get isSupported => isSupportedArchiveFormat(file.extension);

  /// human readable string representing the file size
  String get prettyFileSize => !file.isDir ? filesize(file.size) : '';

  /// human readable string representing the date
  String get prettyDate => appDateFormatFromString(file.modTime);

  @override
  List<Object> get props => [
        file,
        isSupported,
        prettyFileSize,
        prettyDate,
      ];
}
