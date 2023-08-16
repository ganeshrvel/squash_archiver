import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';

/// Model for password request
class PasswordRequest {
  /// [FileListingRequest] object
  final FileListingRequest fileListingRequest;

  /// set [invalidPassword] as true if password was incorrect
  final bool invalidPassword;

  PasswordRequest({
    required this.fileListingRequest,
    required this.invalidPassword,
  });
}
