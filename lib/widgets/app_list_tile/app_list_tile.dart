import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/widgets/inkwell_extended/inkwell_extended.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class AppListTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const AppListTile({
    Key key,
    @required this.selected,
    @required this.icon,
    @required this.onTap,
    @required this.label,
  })  : assert(selected != null),
        assert(icon != null),
        assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _iconColor = selected ? AppColors.white : AppColors.blue;
    final _tileColor = selected ? AppColors.blue : null;
    final _tileTextColor =
        selected ? AppColors.white : AppColors.black.withOpacity(0.8);

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
