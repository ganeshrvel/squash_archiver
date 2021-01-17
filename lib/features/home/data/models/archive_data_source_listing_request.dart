import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:meta/meta.dart';

class ArchiveDataSourceListingRequest {
  final ListArchive request;

  ArchiveDataSourceListingRequest({
    @required this.request,
  }) : assert(request != null);
}
