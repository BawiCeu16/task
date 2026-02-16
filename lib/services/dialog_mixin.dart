/// Mixin for pages that manage modal dialogs
import 'package:flutter/material.dart';

mixin DialogMixin {
  /// Show a dialog and handle navigation
  Future<T?> showModalDialog<T>(
    BuildContext context,
    Widget dialog, {
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Pop and refresh parent
  void popAndRefresh(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  /// Navigate to page and rebuild on return
  Future<T?> pushAndRebuild<T extends Object?>(
    BuildContext context,
    MaterialPageRoute<T> route,
  ) async {
    final result = await Navigator.push(context, route);
    return result;
  }

  /// Navigation with dialog
  Future<T?> navigateWithDialog<T>(BuildContext context, Widget dialog) {
    return showDialog<T>(context: context, builder: (_) => dialog);
  }
}
