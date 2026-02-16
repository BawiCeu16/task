/// Common dialog utilities and helper functions
import 'package:flutter/material.dart';
import 'package:task/constants/app_constants.dart';

/// Helper to show a simple info dialog
Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  String closeText = AppConstants.buttonClose,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.dialogBorderRadius,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(closeText),
        ),
      ],
    ),
  );
}

/// Helper to show a simple text-based info dialog
Future<void> showInfoDetailsDialog({
  required BuildContext context,
  required String title,
  required List<String> details,
  String closeText = AppConstants.buttonClose,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.dialogBorderRadius,
      ),
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final detail in details) Text(detail)],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(closeText),
        ),
      ],
    ),
  );
}

/// Helper to create a standard dialog with custom content
AlertDialog createStandardDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget>? actions,
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: AppConstants.dialogBorderRadius,
    ),
    title: Text(title),
    content: content,
    actions: actions,
  );
}

/// Standard dialog action buttons
FilledButton createCancelButton({
  required BuildContext context,
  VoidCallback? onPressed,
}) {
  return FilledButton.tonal(
    onPressed: onPressed ?? () => Navigator.pop(context),
    child: const Text(AppConstants.buttonCancel),
  );
}

FilledButton createConfirmButton({
  required BuildContext context,
  required String label,
  required VoidCallback onPressed,
  bool isDestructive = false,
}) {
  return FilledButton(
    style: isDestructive
        ? ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.error,
            ),
          )
        : null,
    onPressed: onPressed,
    child: Text(label),
  );
}
