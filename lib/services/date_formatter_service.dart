/// Date and time formatting utilities
import 'package:intl/intl.dart';

class DateFormatterService {
  // Single instance of DateFormat to avoid repeated creation
  static final _dateFormat = DateFormat.yMMMd();
  static final _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final _dateOnlyFormat = DateFormat('yyyy-MM-dd');
  static final _timeOnlyFormat = DateFormat('HH:mm:ss');

  /// Format date in medium format (e.g., "Jan 1, 2024")
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format date and time (e.g., "2024-01-01 14:30:45")
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Parse ISO 8601 date string and return formatted date
  static String formatDateFromISO(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      return formatDate(date);
    } catch (_) {
      return isoString; // Return original if parsing fails
    }
  }

  /// Format date with time from ISO string
  static String formatDateTimeFromISO(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return formatDateTime(dateTime);
    } catch (_) {
      return isoString;
    }
  }

  /// Get short date format (e.g., "2024-01-01")
  static String getShortDateFromISO(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      return _dateOnlyFormat.format(date);
    } catch (_) {
      return isoString;
    }
  }

  /// Get time only format from ISO (e.g., "14:30:45")
  static String getTimeFromISO(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return _timeOnlyFormat.format(dateTime);
    } catch (_) {
      return isoString;
    }
  }

  /// Get formatted date with time like "2024-01-01 | 14:30:45"
  static String getFullDateTimeFromISO(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final dateStr =
          "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
      final timeStr =
          "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}.${dt.second.toString().padLeft(2, '0')}";
      return "$dateStr | $timeStr";
    } catch (_) {
      return isoString;
    }
  }

  /// Find oldest date in a list of ISO date strings
  static DateTime? findOldestDate(List<String> isoStrings) {
    DateTime? oldest;
    for (final iso in isoStrings) {
      try {
        final dt = DateTime.parse(iso);
        if (oldest == null || dt.isBefore(oldest)) {
          oldest = dt;
        }
      } catch (_) {
        // Skip invalid dates
      }
    }
    return oldest;
  }

  /// Find newest date in a list of ISO date strings
  static DateTime? findNewestDate(List<String> isoStrings) {
    DateTime? newest;
    for (final iso in isoStrings) {
      try {
        final dt = DateTime.parse(iso);
        if (newest == null || dt.isAfter(newest)) {
          newest = dt;
        }
      } catch (_) {
        // Skip invalid dates
      }
    }
    return newest;
  }
}
