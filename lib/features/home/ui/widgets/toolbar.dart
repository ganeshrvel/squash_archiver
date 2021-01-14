import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/sliver/app_sliver_header.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class HomeToolbar extends StatelessWidget {
  Widget _buildToobarButtons(
    BuildContext context, {
    @required IconData icon,
    @required String label,
    @required VoidCallback onPressed,
  }) {
    return Button(
      text: label,
      icon: icon,
      onPressed: onPressed,
      buttonType: ButtonType.TILE,
      buttonColor: ButtonColorType.ColorF1F,
      buttonTextColor: ButtonColorType.BLACK,
      iconButtonIconSize: 40,
      textAutoCapitalize: false,
      width: 80,
      height: 80,
      textVariant: TextVariants.caption,
      fontWeight: FontWeight.w400,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppSliverHeader(
        backgroundColor: AppColors.colorF1F,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildToobarButtons(
                    context,
                    icon: MaterialCommunityIcons.folder_zip_outline,
                    label: 'Create',
                    onPressed: () {},
                  ),
                  _buildToobarButtons(
                    context,
                    icon: MaterialCommunityIcons.file_plus_outline,
                    label: 'Add',
                    onPressed: () {},
                  ),
                  _buildToobarButtons(
                    context,
                    icon: Icons.exit_to_app,
                    label: 'Extract',
                    onPressed: () {},
                  ),
                  _buildToobarButtons(
                    context,
                    icon: MaterialCommunityIcons.file_eye_outline,
                    label: 'View',
                    onPressed: () {},
                  ),
                  _buildToobarButtons(
                    context,
                    icon: MaterialCommunityIcons.file_check_outline,
                    label: 'Test',
                    onPressed: () {},
                  ),
                  _buildToobarButtons(
                    context,
                    icon: Icons.search,
                    label: 'Find',
                    onPressed: () {},
                  ),
                  _buildToobarButtons(
                    context,
                    icon: Icons.info_outline,
                    label: 'Info',
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
        maximumExtent: 80,
        minimumExtent: 80,
      ),
    );
  }
}
