import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/features/home/data/models/file_explorer_toolbar_entiry.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

class FileExplorerToolbarActions {
  static List<ToolbarItem> getActions({
    required List<FileExplorerToolbarItemEntity> entities,
  }) {
    return [
      for (final entity in entities)
        ToolBarIconButton(
          icon: MacosIcon(
            entity.iconData,
          ),
          onPressed: () => isNotNull(entity.loading) ? entity.onPressed : null,
          label: entity.label,
          showLabel: true,
          tooltipMessage: entity.label,
        ),
    ];
  }
}
