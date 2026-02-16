/// Mixin for error handling across pages
import 'package:flutter/material.dart';

mixin ErrorHandlerMixin {
  /// Handle and display errors
  void handleError(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    final message = error.toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
        action: onRetry != null
            ? SnackBarAction(label: 'Retry', onPressed: onRetry)
            : null,
      ),
    );
  }

  /// Try-execute with error handling
  Future<T?> tryExecute<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? errorMessage,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      final result = await operation();
      onSuccess?.call();
      return result;
    } catch (e) {
      handleError(context, errorMessage ?? e);
      onError?.call();
      return null;
    }
  }

  /// Safe state update with error handling
  void safeSetState(VoidCallback fn, {required BuildContext context}) {
    try {
      if (context.mounted) {
        fn();
      }
    } catch (e) {
      handleError(context, e);
    }
  }
}
