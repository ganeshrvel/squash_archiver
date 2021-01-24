import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/features/home/data/models/file_listing_request.dart';
import 'package:squash_archiver/features/home/data/models/password_request.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/button/confirm_action_buttons.dart';
import 'package:squash_archiver/widgets/dialogs/app_dialog.dart';
import 'package:squash_archiver/widgets/text/textography.dart';
import 'package:squash_archiver/widgets/text_field/text_field_regular_input.dart';

class FileExplorerPasswordOverlay extends StatefulWidget {
  /// should overlay be visible
  final bool visible;

  /// [PasswordRequest] object
  final PasswordRequest passwordRequest;

  /// [bool] true if the password was invalid
  final bool invalidPassword;

  /// On tapping ok
  final Function({
    @required FileListingRequest fileListingRequest,
    @required String password,
  }) onOk;

  /// On tapping cancel
  final Function() onCancel;

  const FileExplorerPasswordOverlay({
    Key key,
    @required this.visible,
    @required this.invalidPassword,
    @required this.passwordRequest,
    @required this.onOk,
    @required this.onCancel,
  })  : assert(visible != null),
        assert(invalidPassword != null),
        assert(passwordRequest != null),
        assert(onOk != null),
        assert(onCancel != null),
        super(key: key);

  @override
  _FileExplorerPasswordOverlayState createState() =>
      _FileExplorerPasswordOverlayState();
}

class _FileExplorerPasswordOverlayState
    extends SfWidget<FileExplorerPasswordOverlay> {
  TextEditingController _passwordTextController;

  bool get _visible => widget.visible;

  bool get _invalidPassword => widget.invalidPassword;

  PasswordRequest get _passwordRequest => widget.passwordRequest;

  FileListingRequest get _fileListingRequest =>
      widget.passwordRequest.fileListingRequest;

  Function({
    @required FileListingRequest fileListingRequest,
    @required String password,
  }) get _onOk => widget.onOk;

  Function() get _onCancel => widget.onCancel;

  @override
  void initState() {
    _passwordTextController ??= TextEditingController();

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

    return PortalEntry(
      visible: _visible,
      portal: Container(
        color: AppColors.white.withOpacity(0.1),
        child: Center(
          child: AppDialog(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Textography(
                  'Enter password for "${_fileListingRequest.filename}"',
                  color: AppColors.color797,
                  variant: TextVariant.small1,
                  fontWeight: FontWeight.bold,
                ),
                TextFieldRegularInput(
                  onChanged: (value) {},
                  controller: _passwordTextController,
                  hintText: 'Password',
                  errorText: _errorText,
                ),
              ],
            ),
          ),
        ),
      ),
      child: Container(),
    );
  }
}
