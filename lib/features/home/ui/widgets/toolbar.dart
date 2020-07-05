import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/sliver/app_sliver_header.dart';

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
      buttonType: ButtonTypes.TILE,
      buttonColor: ButtonColorTypes.ColorF1F,
      buttonTextColor: ButtonColorTypes.BLACK,
      iconButtonIconSize: 40,
      textAutoCapitalize: false,
      width: 70,
      height: 70,
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
                    icon: Icons.add,
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
                    icon: Icons.remove_red_eye,
                    label: 'View',
                    onPressed: () {},
                  ),
                  _buildToobarButtons(
                    context,
                    icon: Icons.check,
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
                    icon: Icons.info,
                    label: 'Info',
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
        maximumExtent: 70,
        minimumExtent: 70,
      ),
    );
  }
}
