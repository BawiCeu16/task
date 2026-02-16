/// Reusable ColorPicker widget for selecting colors in dialogs
import 'package:flutter/material.dart';
import 'package:task/constants/app_constants.dart';
import 'package:task/widgets/icon_mapper.dart';

class ColorPicker extends StatelessWidget {
  final int? selectedColor;
  final ValueChanged<int?> onColorSelected;
  final List<int?> availableColors;
  final bool showLabel;
  final String label;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.availableColors = AppConstants.availableColors,
    this.showLabel = true,
    this.label = 'Select Color',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[Text(label), const SizedBox(height: 8)],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final color in availableColors)
                _buildColorOption(context, color),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorOption(BuildContext context, int? color) {
    final isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.colorPickerMargin,
        ),
        width: AppConstants.colorPickerSize,
        height: AppConstants.colorPickerSize,
        decoration: BoxDecoration(
          color: color != null ? Color(color) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).disabledColor,
            width: isSelected ? AppConstants.colorPickerBorderWidth : 1,
          ),
        ),
        child: color == null
            ? Icon(
                remixIcon(Icons.block),
                size: 16,
                color: Theme.of(context).disabledColor,
              )
            : null,
      ),
    );
  }
}
