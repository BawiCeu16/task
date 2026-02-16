/// Reusable ConfirmationDialog for consistent delete and confirmation dialogs
import 'package:flutter/material.dart';
import 'package:task/constants/app_constants.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = AppConstants.buttonConfirm,
    this.cancelText = AppConstants.buttonCancel,
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.dialogBorderRadius,
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        FilledButton.tonal(
          onPressed: () {
            onCancel?.call();
            Navigator.pop(context, false);
          },
          child: Text(cancelText),
        ),
        FilledButton(
          style: isDestructive
              ? ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.error,
                  ),
                )
              : null,
          onPressed: () {
            onConfirm();
            Navigator.pop(context, true);
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Show confirmation dialog as a modal
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = AppConstants.buttonConfirm,
  String cancelText = AppConstants.buttonCancel,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => ConfirmationDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm ?? () {},
      onCancel: onCancel,
      isDestructive: isDestructive,
    ),
  );
}
