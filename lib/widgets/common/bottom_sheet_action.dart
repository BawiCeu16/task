/// Reusable widget for bottom sheet action items (ListTile-based)
import 'package:flutter/material.dart';
import 'package:task/constants/app_constants.dart';
import 'package:task/widgets/icon_mapper.dart';

enum BottomSheetActionPosition { top, middle, bottom, single }

class BottomSheetAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final BottomSheetActionPosition position;
  final bool isDestructive;
  final String? subtitle;

  const BottomSheetAction({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.position = BottomSheetActionPosition.middle,
    this.isDestructive = false,
    this.subtitle,
  });

  BorderRadius get _borderRadius {
    switch (position) {
      case BottomSheetActionPosition.top:
        return AppConstants.topBorderRadius;
      case BottomSheetActionPosition.bottom:
        return AppConstants.bottomBorderRadius;
      case BottomSheetActionPosition.single:
        return AppConstants.cardBorderRadius;
      case BottomSheetActionPosition.middle:
        return AppConstants.middleBorderRadius;
    }
  }

  EdgeInsets get _margin {
    switch (position) {
      case BottomSheetActionPosition.top:
        return const EdgeInsets.only(top: 0, bottom: 1.5);
      case BottomSheetActionPosition.bottom:
        return const EdgeInsets.only(top: 1.5, bottom: 0);
      case BottomSheetActionPosition.single:
        return EdgeInsets.zero;
      case BottomSheetActionPosition.middle:
        return const EdgeInsets.only(top: 1.5, bottom: 1.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: _margin,
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
        leading: Icon(
          remixIcon(icon),
          color: isDestructive ? Theme.of(context).colorScheme.error : null,
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        onTap: onTap,
      ),
    );
  }
}

/// Helper to create multiple connected actions
class BottomSheetActionGroup extends StatelessWidget {
  final List<
    ({
      IconData icon,
      String title,
      VoidCallback onTap,
      bool isDestructive,
      String? subtitle,
    })
  >
  actions;

  const BottomSheetActionGroup({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < actions.length; i++)
          BottomSheetAction(
            icon: actions[i].icon,
            title: actions[i].title,
            onTap: actions[i].onTap,
            isDestructive: actions[i].isDestructive,
            subtitle: actions[i].subtitle,
            position: actions.length == 1
                ? BottomSheetActionPosition.single
                : i == 0
                ? BottomSheetActionPosition.top
                : i == actions.length - 1
                ? BottomSheetActionPosition.bottom
                : BottomSheetActionPosition.middle,
          ),
      ],
    );
  }
}
