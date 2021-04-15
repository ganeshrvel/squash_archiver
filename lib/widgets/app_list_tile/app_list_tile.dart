import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/widgets/inkwell_extended/inkwell_extended.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class AppListTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const AppListTile({
    Key? key,
    required this.selected,
    required this.icon,
    required this.onTap,
    required this.label,
  })  :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _palette = getPalette(context);

    final _iconColor = selected
        ? _palette.sidebarTileIconContrastColor
        : _palette.sidebarTileIconColor;
    final _tileColor = selected ? _palette.sidebarSelectionColor : null;
    final _tileTextColor = selected
        ? _palette.sidebarTileTextContrastColor
        : _palette.sidebarTileTextColor.withOpacity(0.8);

    return InkWellExtended(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _tileColor,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: _iconColor,
            ),
            const SizedBox(
              width: 7,
            ),
            Textography(
              label,
              variant: TextVariant.body2,
              fontWeight: FontWeight.w600,
              color: _tileTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
