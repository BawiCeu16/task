/// Reusable IconPicker widget for selecting icons in dialogs
import 'package:flutter/material.dart';
import 'package:task/constants/app_constants.dart';
import 'package:task/widgets/icon_mapper.dart';

class IconPicker extends StatelessWidget {
  final int? selectedIcon;
  final ValueChanged<int?> onIconSelected;
  final List<Map<String, IconData>> availableIcons;
  final bool showLabel;
  final String label;

  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    this.availableIcons = AppConstants.defaultFolderIcons,
    this.showLabel = true,
    this.label = 'Select Icon',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[Text(label), const SizedBox(height: 8)],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final iconMap in availableIcons)
              _buildIconOption(context, iconMap),
          ],
        ),
      ],
    );
  }

  Widget _buildIconOption(BuildContext context, Map<String, IconData> iconMap) {
    final iconVal = iconMap.values.first.codePoint;
    final isSelected = selectedIcon == iconVal;

    return InkWell(
      onTap: () => onIconSelected(iconVal),
      borderRadius: BorderRadius.circular(AppConstants.iconPickerContainerSize),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.iconPickerPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Icon(remixIcon(iconMap.values.first)),
      ),
    );
  }
}
