import 'package:meta/meta.dart';

import 'file_listing_request.dart';

/// Model for password request
class PasswordRequest {
  /// [FileListingRequest] object
  final FileListingRequest fileListingRequest;

  /// set [invalidPassword] as true if password was incorrect
  final bool invalidPassword;

  PasswordRequest({
    @required this.fileListingRequest,
    @required this.invalidPassword,
  })  : assert(fileListingRequest != null),
        assert(invalidPassword != null);
}
