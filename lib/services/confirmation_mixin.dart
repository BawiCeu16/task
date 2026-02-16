/// Mixin for pages that need confirmation dialogs
import 'package:flutter/material.dart';
import 'package:task/widgets/common/index.dart';

mixin ConfirmationMixin {
  /// Show a confirmation dialog and return bool result
  Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showConfirmationDialog(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
    );
  }

  /// Deprecated: Use showConfirmation instead
  @Deprecated('Use showConfirmation instead')
  Future<bool?> confirm(BuildContext c, String title, String body) {
    return showConfirmation(c, title: title, content: body);
  }
}
