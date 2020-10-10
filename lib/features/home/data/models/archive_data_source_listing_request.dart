import 'package:archiver_ffi/archiver_ffi.dart';
import 'package:meta/meta.dart';

class ArchiveDataSourceListingRequest {
  final ListArchive request;
  final bool isTest;

  ArchiveDataSourceListingRequest({
    @required this.request,
    @required this.isTest,
  })  : assert(request != null),
        assert(isTest != null);
}
