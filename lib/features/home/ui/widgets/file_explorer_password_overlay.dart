import 'package:flutter/cupertino.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/data/models/password_request.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/confirm_action_buttons.dart';
import 'package:squash_archiver/widgets/overlays/app_overlay.dart';
import 'package:squash_archiver/widgets/text/textography.dart';
import 'package:squash_archiver/widgets/text_field/text_field_password_input.dart';

class FileExplorerPasswordOverlay extends StatefulWidget {
  /// should overlay be visible
  final bool visible;

  /// [PasswordRequest] object
  final PasswordRequest passwordRequest;

  /// [bool] true if the password was invalid
  final bool invalidPassword;

  /// [String] placeholder value for the text input
  final String? placeholder;

  /// On tapping ok
  final Function({
    required FileListingRequest fileListingRequest,
    required String password,
  }) onOk;

  /// On tapping cancel
  final Function() onCancel;

  final ScrollController scrollController;

  const FileExplorerPasswordOverlay({
    super.key,
    required this.visible,
    required this.invalidPassword,
    required this.passwordRequest,
    required this.onOk,
    required this.onCancel,
    required this.scrollController,
    this.placeholder = 'Password',
  });

  @override
  _FileExplorerPasswordOverlayState createState() =>
      _FileExplorerPasswordOverlayState();
}

class _FileExplorerPasswordOverlayState
    extends SfWidget<FileExplorerPasswordOverlay> {
  late final TextEditingController _passwordTextController =
      TextEditingController();

  ScrollController get _scrollController => widget.scrollController;

  bool get _visible => widget.visible;

  bool get _invalidPassword => widget.invalidPassword;

  PasswordRequest get _passwordRequest => widget.passwordRequest;

  FileListingRequest get _fileListingRequest =>
      widget.passwordRequest.fileListingRequest;

  Function({
    required FileListingRequest fileListingRequest,
    required String password,
  }) get _onOk => widget.onOk;

  Function() get _onCancel => widget.onCancel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _errorText = _invalidPassword ? 'Invalid password' : null;

    return AppOverlay(
      visible: _visible,
      actionContainer: ConfirmActionButtons(
        onOk: () {
          _onOk(
            password: _passwordTextController.text,
            fileListingRequest: _fileListingRequest,
          );
        },
        onCancel: _onCancel,
        shouldPopOnButtonClick: false,
      ),
      content: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Textography(
              'Enter password for "${_fileListingRequest.filename}"',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              variant: TextVariant.Headline,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldPasswordInput(
            onChanged: (value) {},
            controller: _passwordTextController,
            placeholder: widget.placeholder,
            errorText: _errorText,
            scrollController: _scrollController,
            onSubmitted: (value) {
              _onOk(
                password: value,
                fileListingRequest: _fileListingRequest,
              );
            },
          ),
        ],
      ),
    );
  }
}
