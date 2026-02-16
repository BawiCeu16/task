/// Task statistics and calculations service
class TaskStatsService {
  /// Calculate completed task count
  static int getCompletedCount(List<Map<String, dynamic>> tasks) {
    return tasks.where((t) => (t['isDone'] ?? false) as bool).length;
  }

  /// Calculate incomplete task count
  static int getIncompleteCount(List<Map<String, dynamic>> tasks) {
    return tasks.length - getCompletedCount(tasks);
  }

  /// Get completion percentage
  static double getCompletionPercentage(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) return 0.0;
    return getCompletedCount(tasks) / tasks.length;
  }

  /// Count tasks without folder assignment
  static int getTasksWithoutFolder(List<Map<String, dynamic>> tasks) {
    return tasks.where((t) => (t['folder'] ?? '').toString().isEmpty).length;
  }

  /// Count tasks without category assignment
  static int getTasksWithoutCategory(List<Map<String, dynamic>> tasks) {
    return tasks.where((t) => (t['category'] ?? '').toString().isEmpty).length;
  }

  /// Get tasks by folder
  static List<Map<String, dynamic>> getTasksByFolder(
    List<Map<String, dynamic>> tasks,
    String folder,
  ) {
    return tasks.where((t) => (t['folder'] ?? '') == folder).toList();
  }

  /// Get tasks by category
  static List<Map<String, dynamic>> getTasksByCategory(
    List<Map<String, dynamic>> tasks,
    String category,
  ) {
    return tasks.where((t) => (t['category'] ?? '') == category).toList();
  }

  /// Get completed tasks
  static List<Map<String, dynamic>> getCompletedTasks(
    List<Map<String, dynamic>> tasks,
  ) {
    return tasks.where((t) => (t['isDone'] ?? false) as bool).toList();
  }

  /// Get incomplete tasks
  static List<Map<String, dynamic>> getIncompleteTasks(
    List<Map<String, dynamic>> tasks,
  ) {
    return tasks.where((t) => !(t['isDone'] ?? false)).toList();
  }

  /// Get date range string from tasks
  static String getDateRangeString(
    List<Map<String, dynamic>> tasks,
    String Function(DateTime) formatter,
  ) {
    if (tasks.isEmpty) return '-';

    DateTime? oldest;
    DateTime? newest;

    for (var t in tasks) {
      final iso = (t['createdDate'] ?? '') as String;
      try {
        final dt = DateTime.parse(iso);
        if (oldest == null || dt.isBefore(oldest)) oldest = dt;
        if (newest == null || dt.isAfter(newest)) newest = dt;
      } catch (_) {}
    }

    final oldestStr = oldest == null ? '-' : formatter(oldest);
    final newestStr = newest == null ? '-' : formatter(newest);

    return 'Oldest: $oldestStr | Newest: $newestStr';
  }
}
