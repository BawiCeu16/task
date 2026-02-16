# Flutter Task App - Services Layer Guide

This guide provides comprehensive documentation for the new service layer architecture introduced for clean code & permanent development practices.

## Overview

The services layer comprises reusable utilities, business logic, and cross-cutting concerns extracted from pages and widgets. This architecture enables:

- **Code Reusability**: Extract logic used across multiple pages
- **Separation of Concerns**: Business logic stays separate from UI
- **Maintainability**: Single source of truth for common operations
- **Testability**: Services can be unit tested independently
- **Consistency**: Standardized patterns across the app

## Services Architecture

### Directory Structure

```
lib/services/
├── index.dart                    # Barrel export for all services
├── responsive_service.dart       # Responsive design utilities
├── date_formatter_service.dart   # Date/time formatting
├── task_stats_service.dart       # Statistics & calculations
├── file_service.dart             # File & image operations
├── confirmation_mixin.dart       # Confirmation dialogs (mixin)
├── snackbar_mixin.dart          # Snackbar notifications (mixin)
├── dialog_mixin.dart            # Dialog & navigation (mixin)
└── error_handler_mixin.dart     # Error handling (mixin)
```

## Service Reference

### 1. ResponsiveService

**Purpose**: Centralize responsive breakpoints and layout detection.

**Location**: `lib/services/responsive_service.dart`

**Static Methods**:

```dart
// Get grid column count based on layout
static int getGridCrossAxisCount(double maxWidth)

// Check if wide layout (desktop >= 800px)
static bool isWideLayout(double maxWidth)

// Check if tablet layout (600px <= width < 800px)
static bool isTabletLayout(double maxWidth)

// Check if mobile layout (width < 600px)
static bool isMobileLayout(double maxWidth)
```

**Example Usage**:

```dart
final crossAxisCount = ResponsiveService.getGridCrossAxisCount(
  constraints.maxWidth,
);

if (ResponsiveService.isWideLayout(MediaQuery.of(context).size.width)) {
  // Show desktop layout
} else {
  // Show mobile layout
}
```

**Breakpoints**:
- **Desktop**: ≥ 800 pixels
- **Tablet**: 600 - 799 pixels
- **Mobile**: < 600 pixels

---

### 2. DateFormatterService

**Purpose**: Centralize all date/time formatting operations.

**Location**: `lib/services/date_formatter_service.dart`

**Static Methods**:

```dart
// Format DateTime to "Jan 15, 2025"
static String formatDate(DateTime date)

// Format DateTime to "Jan 15, 2025 at 2:30 PM"
static String formatDateTime(DateTime date)

// Parse ISO string and format
static String formatDateFromISO(String isoString)

// Get full DateTime from ISO string
static DateTime? getFullDateTimeFromISO(String isoString)
```

**Example Usage**:

```dart
// Format a date
final formatted = DateFormatterService.formatDate(DateTime.now());
print(formatted); // Output: "Jan 15, 2025"

// Format from ISO string
final fromISO = DateFormatterService.formatDateFromISO('2025-01-15T14:30:00.000Z');
print(fromISO); // Output: "Jan 15, 2025 at 2:30 PM"

// Get DateTime object from ISO
final dateTime = DateFormatterService.getFullDateTimeFromISO('2025-01-15T14:30:00.000Z');
```

---

### 3. TaskStatsService

**Purpose**: Calculate task statistics and metrics across the app.

**Location**: `lib/services/task_stats_service.dart`

**Static Methods**:

```dart
// Count completed tasks
static int getCompletedCount(List<Map<String, dynamic>> tasks)

// Count incomplete tasks
static int getIncompleteCount(List<Map<String, dynamic>> tasks)

// Get completion percentage (0.0 to 1.0)
static double getCompletionPercentage(List<Map<String, dynamic>> tasks)

// Count tasks without folder
static int getTasksWithoutFolder(List<Map<String, dynamic>> tasks)

// Count tasks without category
static int getTasksWithoutCategory(List<Map<String, dynamic>> tasks)

// Get all completed tasks
static List<Map<String, dynamic>> getCompletedTasks(List<Map<String, dynamic>> tasks)

// Get all incomplete tasks
static List<Map<String, dynamic>> getIncompleteTasks(List<Map<String, dynamic>> tasks)

// Get tasks by folder name
static List<Map<String, dynamic>> getTasksByFolder(
  List<Map<String, dynamic>> tasks,
  String folder,
)

// Get tasks by category name
static List<Map<String, dynamic>> getTasksByCategory(
  List<Map<String, dynamic>> tasks,
  String category,
)

// Get formatted date range string
static String getDateRangeString(
  List<Map<String, dynamic>> tasks,
  String Function(DateTime) formatter,
)
```

**Example Usage**:

```dart
final tasks = provider.tasks;

// Get metrics
final completed = TaskStatsService.getCompletedCount(tasks);
final incomplete = TaskStatsService.getIncompleteCount(tasks);
final withoutFolder = TaskStatsService.getTasksWithoutFolder(tasks);
final percentage = TaskStatsService.getCompletionPercentage(tasks);

// Get filtered lists
final completedTasks = TaskStatsService.getCompletedTasks(tasks);
final folderTasks = TaskStatsService.getTasksByFolder(tasks, 'Work');

// Get date range
final dateRange = TaskStatsService.getDateRangeString(
  tasks,
  (date) => DateFormatterService.formatDate(date),
);
print(dateRange); // Output: "Oldest: Jan 1, 2025 | Newest: Jan 15, 2025"
```

---

### 4. FileService

**Purpose**: Handle file and image operations.

**Location**: `lib/services/file_service.dart`

**Static Methods**:

```dart
// Pick image from gallery
static Future<String?> pickImage()

// Check if image file exists
static Future<bool> imageExists(String? imagePath)

// Get image size in MB
static Future<double> getImageSizeInMB(String imagePath)

// Delete image file
static Future<bool> deleteImage(String? imagePath)
```

**Example Usage**:

```dart
// Pick an image
final imagePath = await FileService.pickImage();
if (imagePath != null) {
  // Image selected
}

// Check if exists
if (await FileService.imageExists(_imagePath)) {
  // Process image
}

// Get size
final sizeMB = await FileService.getImageSizeInMB(_imagePath);
print('Image size: ${sizeMB.toStringAsFixed(2)} MB');

// Delete image
await FileService.deleteImage(_imagePath);
```

---

## Mixins Reference

Mixins provide optional features to pages via `with` declaration. They enable code reuse without base class conflicts.

### 1. ConfirmationMixin

**Purpose**: Standardized confirmation dialog calling for delete operations.

**Location**: `lib/services/confirmation_mixin.dart`

**Methods**:

```dart
// Show confirmation dialog (recommended)
Future<bool?> showConfirmation(
  BuildContext context, {
  required String title,
  required String content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDestructive = false,
})

// Deprecated: Use showConfirmation instead
@Deprecated('Use showConfirmation instead')
Future<bool?> confirm(BuildContext c, String title, String body)
```

**Example Usage in Page**:

```dart
class MyPage extends StatefulWidget {...}

class _MyPageState extends State<MyPage> with ConfirmationMixin {
  void _deleteItem() async {
    final confirmed = await showConfirmation(
      context,
      title: 'Delete Item?',
      content: 'This action cannot be undone.',
      isDestructive: true,
    );
    
    if (confirmed == true) {
      // Perform deletion
    }
  }
}
```

**How to Add to Page**:

```dart
// Before
class _MyPageState extends State<MyPage> {

// After
class _MyPageState extends State<MyPage> with ConfirmationMixin {
```

---

### 2. SnackBarMixin

**Purpose**: Centralized and themed snackbar notifications.

**Location**: `lib/services/snackbar_mixin.dart`

**Methods**:

```dart
// Show success snackbar (green, 2 seconds)
void showSuccessSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
})

// Show error snackbar (red, 3 seconds)
void showErrorSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
})

// Show info snackbar (gray, 2 seconds)
void showInfoSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
})

// Show custom snackbar
void showSnackBar(
  BuildContext context,
  String message, {
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 2),
})
```

**Example Usage in Page**:

```dart
class _MyPageState extends State<MyPage> with SnackBarMixin {
  void _saveItem() {
    try {
      provider.saveItem(item);
      showSuccessSnackBar(context, 'Item saved successfully');
    } catch (e) {
      showErrorSnackBar(context, 'Error: $e');
    }
  }
}
```

---

### 3. DialogMixin

**Purpose**: Dialog and navigation management utilities.

**Location**: `lib/services/dialog_mixin.dart`

**Methods**:

```dart
// Show modal dialog
Future<T?> showModalDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
})

// Pop and trigger rebuild
void popAndRefresh(BuildContext context)

// Push and rebuild
Future<T?> pushAndRebuild<T>(
  BuildContext context,
  Route<T> route,
})
```

**Example Usage**:

```dart
class _SettingsState extends State<Settings> with DialogMixin {
  void _showThemeDialog() async {
    await showModalDialog(
      context,
      builder: (_) => const ThemeSelectionDialog(),
    );
  }
}
```

---

### 4. ErrorHandlerMixin

**Purpose**: Cross-page error handling patterns.

**Location**: `lib/services/error_handler_mixin.dart`

**Methods**:

```dart
// Handle and display error
void handleError(BuildContext context, dynamic error, [String? prefix])

// Safely execute async operations with error handling
Future<T?> tryExecute<T>(
  BuildContext context,
  Future<T> Function() operation, {
  String? errorPrefix,
})

// Safe setState with mounted check
void safeSetState(VoidCallback fn)
```

**Example Usage**:

```dart
class _ListPageState extends State<ListPage> with ErrorHandlerMixin {
  Future<void> _loadData() async {
    final result = await tryExecute(
      context,
      () => provider.fetchItems(),
      errorPrefix: 'Failed to load',
    );
    
    if (result != null) {
      safeSetState(() {
        _items = result;
      });
    }
  }
}
```

---

## Importing Services

### Barrel Import (Recommended)

```dart
import 'package:task/services/index.dart';
```

This imports all services and mixins at once.

### Individual Imports

```dart
import 'package:task/services/responsive_service.dart';
import 'package:task/services/date_formatter_service.dart';
import 'package:task/services/task_stats_service.dart';
import 'package:task/services/confirmation_mixin.dart';
```

---

## Usage Patterns

### Pattern 1: Page with Multiple Mixins

```dart
class _ManageAllPageState extends State<ManageAllPage>
    with ConfirmationMixin, SnackBarMixin {
  
  void _deleteAll() async {
    final confirmed = await showConfirmation(
      context,
      title: 'Delete All?',
      content: 'This cannot be undone.',
    );
    
    if (confirmed == true) {
      try {
        await provider.deleteAll();
        showSuccessSnackBar(context, 'All items deleted');
      } catch (e) {
        showErrorSnackBar(context, 'Error: $e');
      }
    }
  }
}
```

### Pattern 2: Statistics with Services

```dart
final completed = TaskStatsService.getCompletedCount(tasks);
final incomplete = TaskStatsService.getIncompleteCount(tasks);
final percentage = TaskStatsService.getCompletionPercentage(tasks);

print('Progress: $completed/$incomplete tasks done ($percentage% complete)');
```

### Pattern 3: Responsive Layout

```dart
return Consumer<ThemeProvider>(
  builder: (context, theme, _) {
    final isWide = ResponsiveService.isWideLayout(
      MediaQuery.of(context).size.width,
    );
    
    return GridView.count(
      crossAxisCount: ResponsiveService.getGridCrossAxisCount(
        MediaQuery.of(context).size.width,
      ),
      children: items.map((item) => ItemCard(item: item)).toList(),
    );
  },
);
```

---

## Constants Integration

The services layer works seamlessly with `AppConstants` for text strings:

```dart
// From AppConstants
static const String dialogTitleDeleteConfirm = 'Confirm Delete';
static const String confirmDeleteAllFolders = "Delete all folders?";
static const String msgSuccess = 'Success!';

// Use with services
await showConfirmation(
  context,
  title: AppConstants.dialogTitleDeleteConfirm,
  content: AppConstants.confirmDeleteAllFolders,
);

showSuccessSnackBar(context, AppConstants.msgSuccess);
```

---

## Best Practices

1. **Always use Barrel Imports**: `import 'package:task/services/index.dart';`

2. **Page Organization**:
   - Add mixins needed for the page: `with ConfirmationMixin, SnackBarMixin`
   - Use static methods from services directly
   - Keep page code focused on UI/state management

3. **Error Handling**:
   - Use `ConfirmationMixin` for delete confirmations
   - Use `SnackBarMixin` for user feedback
   - Use `ErrorHandlerMixin` for try-catch patterns

4. **Date Formatting**:
   - Never hardcode date formats
   - Always use `DateFormatterService` for consistency
   - Leverage `TaskStatsService.getDateRangeString()` for pre-formatted ranges

5. **Responsive Design**:
   - Use `ResponsiveService` breakpoints for consistent layout decisions
   - Don't hardcode breakpoint values (800, 600, etc.) anywhere

---

## Migration Checklist

When refactoring existing pages to use services:

- [ ] Add appropriate mixins to page class declaration
- [ ] Replace manual dialog code with `showConfirmation()`
- [ ] Replace `ScaffoldMessenger.showSnackBar()` with mixin methods
- [ ] Replace date formatting with `DateFormatterService`
- [ ] Replace task calculations with `TaskStatsService` methods
- [ ] Replace responsive checks with `ResponsiveService`
- [ ] Remove old `_confirm()`, `_formatDate()`, and similar methods
- [ ] Test all functionality post-migration
- [ ] Remove any unused imports

---

## Troubleshooting

### "Method not found" Error
- Ensure correct mixin is added: `with ConfirmationMixin, SnackBarMixin`
- Verify barrel import: `import 'package:task/services/index.dart';`

### Snackbar Not Showing
- Confirm `context` is passed to mixin methods
- Ensure page has `Scaffold` parent widget
- Check that `mounted` is true before showing (in async code)

### Responsive Layout Issues
- Use `MediaQuery.of(context).size.width` to get current width
- Call service methods with actual width value
- Test on multiple screen sizes

---

## Contributing to Services

When adding new services:

1. Create new file in `lib/services/`
2. Add to barrel export `services/index.dart`
3. Follow existing patterns (static methods for services, mixins for optional features)
4. Document with JSDoc comments
5. Add usage examples to this guide
6. Test independently with unit tests

---

## Related Documentation

- [App Constants Guide](DEVELOPER_GUIDE.md) - String constants and theming
- [Widget Library](lib/widgets/) - Reusable UI components
- [Project Architecture](README.md) - Overall project structure
