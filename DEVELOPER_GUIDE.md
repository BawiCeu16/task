# Developer Guide: Code Architecture & Reusable Components

## 📋 Table of Contents
1. [Project Structure](#project-structure)
2. [Reusable Widgets](#reusable-widgets)
3. [Constants System](#constants-system)
4. [Best Practices](#best-practices)
5. [Common Patterns](#common-patterns)
6. [Quick Reference](#quick-reference)

---

## Project Structure

### Directory Organization

```
lib/
├── constants/                          # Application-wide constants
│   └── app_constants.dart             # Single source of truth for sizing, colors, text
│
├── pages/                              # Full-screen pages/routes
│   ├── main_pages/                    # Core app pages
│   ├── setting_screens/               # Settings-related pages
│   └── [individual page files]
│
├── provider/                           # State management (Provider)
│   ├── task_provider.dart
│   ├── theme_provider.dart
│   └── app_info_provider.dart
│
├── utils/                              # Utility functions
│   └── category_icons_helper.dart
│
├── widgets/
│   ├── common/                         # ⭐ Reusable components library
│   │   ├── index.dart                 # Barrel export for easy imports
│   │   ├── color_picker.dart          # Color selection widget
│   │   ├── icon_picker.dart           # Icon selection widget
│   │   ├── confirmation_dialog.dart   # Confirmation dialogs
│   │   ├── bottom_sheet_action.dart   # Bottom sheet action items
│   │   └── dialog_utils.dart          # Dialog helper functions
│   │
│   ├── setting_widgets/               # Settings-specific widgets
│   │   ├── top_list_tile.dart
│   │   └── [others]
│   │
│   ├── create_dialog.dart             # Task creation dialog
│   ├── create_folder_dialog.dart      # Folder creation dialog
│   ├── create_category_dialog.dart    # Category creation dialog
│   ├── task_bottom_sheet.dart         # Task actions bottom sheet
│   ├── category_list_item.dart        # Category list display widget
│   ├── list_item.dart                 # Task list item widget
│   ├── task_list_view.dart            # Task list view container
│   ├── task_summary_chart.dart        # Task statistics chart
│   └── icon_mapper.dart               # Icon utility functions
│
└── main.dart                           # App entry point
```

---

## Reusable Widgets

### 1. ColorPicker

**Location**: `lib/widgets/common/color_picker.dart`

**Purpose**: Provides a reusable color selection interface for dialogs

**Usage**:
```dart
import 'package:task/widgets/common/index.dart';

ColorPicker(
  selectedColor: _selectedColor,
  onColorSelected: (color) => setState(() => _selectedColor = color),
  availableColors: AppConstants.availableColors,
  label: 'Select Color',
  showLabel: true,
)
```

**Properties**:
- `selectedColor` (int?): Currently selected color value
- `onColorSelected` (ValueChanged<int?>): Callback when color is selected
- `availableColors` (List<int?>): List of available colors to display
- `showLabel` (bool): Whether to show the label text
- `label` (String): Label to display above color options

**Features**:
- Customizable color palette
- Visual selection indicator
- Scrollable for many colors
- Null/transparent color support

---

### 2. IconPicker

**Location**: `lib/widgets/common/icon_picker.dart`

**Purpose**: Provides a reusable icon selection interface

**Usage**:
```dart
IconPicker(
  selectedIcon: _selectedIcon,
  onIconSelected: (icon) => setState(() => _selectedIcon = icon),
  availableIcons: AppConstants.defaultFolderIcons,
  label: 'Select Icon',
  showLabel: true,
)
```

**Properties**:
- `selectedIcon` (int?): Currently selected icon code point
- `onIconSelected` (ValueChanged<int?>): Callback when icon is selected
- `availableIcons` (List<Map<String, IconData>>): Icons to display
- `showLabel` (bool): Whether to show the label
- `label` (String): Label to display

**Features**:
- Custom icon lists support
- Visual selection state
- Wrap layout for responsive design

---

### 3. ConfirmationDialog

**Location**: `lib/widgets/common/confirmation_dialog.dart`

**Purpose**: Standardized confirmation/delete dialogs

**Usage**:
```dart
// Option 1: Direct widget
ConfirmationDialog(
  title: 'Delete Task?',
  content: 'This cannot be undone',
  isDestructive: true,
  onConfirm: () => deleteTask(),
)

// Option 2: Helper function (recommended)
await showConfirmationDialog(
  context: context,
  title: 'Delete Task?',
  content: 'This cannot be undone',
  isDestructive: true,
  onConfirm: () => deleteTask(),
);
```

**Properties**:
- `title` (String): Dialog title
- `content` (String): Dialog message
- `confirmText` (String): Confirm button label (default: 'Confirm')
- `cancelText` (String): Cancel button label (default: 'Cancel')
- `onConfirm` (VoidCallback): Action on confirm
- `onCancel` (VoidCallback?): Action on cancel
- `isDestructive` (bool): Red button for destructive actions

**Features**:
- Automatic red button styling for destructive actions
- Consistent dialog appearance
- Easy to use helper function

---

### 4. BottomSheetAction

**Location**: `lib/widgets/common/bottom_sheet_action.dart`

**Purpose**: Reusable action items for bottom sheets

**Usage**:
```dart
// Single action
BottomSheetAction(
  icon: Icons.edit,
  title: 'Edit',
  onTap: () => handleEdit(),
  position: BottomSheetActionPosition.single,
)

// Group of actions (recommended)
BottomSheetActionGroup(
  actions: [
    (
      icon: Icons.edit,
      title: 'Edit',
      onTap: () => handleEdit(),
      isDestructive: false,
      subtitle: null,
    ),
    (
      icon: Icons.delete,
      title: 'Delete',
      onTap: () => handleDelete(),
      isDestructive: true,
      subtitle: null,
    ),
  ],
)
```

**Properties** (BottomSheetAction):
- `icon` (IconData): Action icon
- `title` (String): Action label
- `onTap` (VoidCallback): Action callback
- `position` (BottomSheetActionPosition): Position in group (top, middle, bottom, single)
- `isDestructive` (bool): Red icon for destructive actions
- `subtitle` (String?): Optional subtitle

**Positions**:
- `BottomSheetActionPosition.top` - Top item with rounded top
- `BottomSheetActionPosition.middle` - Middle item
- `BottomSheetActionPosition.bottom` - Bottom item with rounded bottom
- `BottomSheetActionPosition.single` - Single item with full rounded corners

**Features**:
- Auto positioning with groups
- Destructive action styling
- Clean separation between items
- Icon color management

---

## Constants System

### Location: `lib/constants/app_constants.dart`

### Border Radius Constants
```dart
AppConstants.borderRadiusMedium      // 12.0
AppConstants.borderRadiusLarge       // 16.0
AppConstants.borderRadiusXLarge      // 20.0
AppConstants.borderRadiusRound       // 100.0 (circle)

// Pre-composed BorderRadius values
AppConstants.cardBorderRadius        // All corners 16.0
AppConstants.dialogBorderRadius      // All corners 20.0
AppConstants.topBorderRadius         // Only top corners 10.0
AppConstants.bottomBorderRadius      // Only bottom corners 10.0
```

### Padding Constants
```dart
AppConstants.paddingSmall            // 8.0
AppConstants.paddingMedium           // 12.0
AppConstants.paddingLarge            // 16.0
AppConstants.paddingXLarge           // 20.0

AppConstants.horizontalPaddingMedium // Horizontal 16.0
AppConstants.horizontalPaddingLarge  // Horizontal 20.0
AppConstants.verticalPaddingMedium   // Vertical 12.0
```

### Spacing Constants
```dart
AppConstants.spacingXSmall           // 4.0
AppConstants.spacingSmall            // 8.0
AppConstants.spacingMedium           // 12.0
AppConstants.spacingLarge            // 16.0
AppConstants.spacingXLarge           // 20.0
```

### Color Palette
```dart
AppConstants.availableColors         // List of colors (null for transparent)
// [null, Red, Orange, Yellow, Green, Blue, Indigo, Purple, Pink, Brown, Grey]
```

### Icon Definitions
```dart
AppConstants.iconTaskAdd             // Icons.add
AppConstants.iconTaskEdit            // Icons.edit
AppConstants.iconTaskDelete          // Icons.delete
AppConstants.iconTaskDone            // Icons.check_circle
AppConstants.iconTaskTodo            // Icons.circle_outlined
AppConstants.iconFolderCreate        // Icons.create_new_folder
AppConstants.iconCategoryAdd         // Icons.add
AppConstants.iconInfo                // Icons.info
```

### Text Constants
```dart
AppConstants.labelNoFolder           // 'No folder'
AppConstants.labelNoCategory         // 'No category'
AppConstants.labelNone               // 'None'

// Dialog buttons
AppConstants.buttonCancel            // 'Cancel'
AppConstants.buttonCreate            // 'Create'
AppConstants.buttonSave              // 'Save'
AppConstants.buttonDelete            // 'Delete'
AppConstants.buttonClose             // 'Close'
```

---

## Best Practices

### ✅ DO's

1. **Use Constants for Styling**
   ```dart
   // Good ✅
   BorderRadius.all(Radius.circular(AppConstants.borderRadiusLarge))
   
   // Avoid ❌
   BorderRadius.all(Radius.circular(16))
   ```

2. **Use Reusable Widgets**
   ```dart
   // Good ✅
   ColorPicker(
     selectedColor: _color,
     onColorSelected: (color) => setState(() => _color = color),
   )
   
   // Avoid ❌
   SingleChildScrollView(
     scrollDirection: Axis.horizontal,
     child: Row(
       children: [
         GestureDetector(...),
         GestureDetector(...),
         // ... repeated logic
       ],
     ),
   )
   ```

3. **Import from Barrel File**
   ```dart
   // Good ✅
   import 'package:task/widgets/common/index.dart';
   
   // Avoid ❌
   import 'package:task/widgets/common/color_picker.dart';
   import 'package:task/widgets/common/icon_picker.dart';
   import 'package:task/widgets/common/confirmation_dialog.dart';
   ```

4. **Use Dialog Helpers**
   ```dart
   // Good ✅
   await showConfirmationDialog(
     context: context,
     title: 'Delete?',
     content: 'Are you sure?',
     isDestructive: true,
     onConfirm: () => deleteItem(),
   );
   
   // Avoid ❌
   await showDialog<bool>(
     context: context,
     builder: (ctx) => AlertDialog(
       // ... repeated dialog code
     ),
   );
   ```

5. **Group Bottom Sheet Actions**
   ```dart
   // Good ✅
   BottomSheetActionGroup(actions: [
     (icon: Icons.edit, title: 'Edit', onTap: () {}, isDestructive: false, subtitle: null),
     (icon: Icons.delete, title: 'Delete', onTap: () {}, isDestructive: true, subtitle: null),
   ])
   
   // Avoid ❌
   Column(children: [
     Card(elevation: 0, shape: ..., child: ListTile(...)),
     Card(elevation: 0, shape: ..., child: ListTile(...)),
   ])
   ```

### ❌ DON'Ts

1. ❌ Avoid hardcoded magic numbers - use `AppConstants`
2. ❌ Avoid duplicate dialog code - use helpers
3. ❌ Avoid custom color pickers - use `ColorPicker` widget
4. ❌ Avoid repeated ListTile+Card patterns - use `BottomSheetAction`
5. ❌ Avoid creating new dialogs for confirmation - use `showConfirmationDialog()`

---

## Common Patterns

### Pattern 1: Task Editing Dialog

```dart
void _editTask(String initialTitle) {
  showDialog(
    context: context,
    builder: (_) => MyCreateDialog(
      initialText: initialTitle,
      onTapSave: (name, isDone, folder, category, color) {
        provider.editTask(index, name,
          isDone: isDone,
          folder: folder,
          category: category,
          color: color,
        );
      },
    ),
  );
}
```

### Pattern 2: Deletion with Confirmation

```dart
Future<void> _deleteTask() async {
  final confirmed = await showConfirmationDialog(
    context: context,
    title: 'Delete Task?',
    content: 'This action cannot be undone.',
    confirmText: 'Delete',
    isDestructive: true,
    onConfirm: () {}, // onConfirm is called before pop
  );
  
  if (confirmed == true) {
    provider.deleteTask(index);
  }
}
```

### Pattern 3: Bottom Sheet with Actions

```dart
void _showTaskOptions(Map<String, dynamic> task) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: BottomSheetActionGroup(
        actions: [
          (
            icon: Icons.edit,
            title: 'Edit',
            onTap: () => Navigator.pop(context),
            isDestructive: false,
            subtitle: null,
          ),
          (
            icon: Icons.delete,
            title: 'Delete',
            onTap: () => _deleteTask(),
            isDestructive: true,
            subtitle: null,
          ),
        ],
      ),
    ),
  );
}
```

### Pattern 4: Item with Color Selection

```dart
class ItemCreationPage extends StatefulWidget {
  @override
  State<ItemCreationPage> createState() => _ItemCreationPageState();
}

class _ItemCreationPageState extends State<ItemCreationPage> {
  int? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Item Name'),
          ),
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingLarge),
            child: ColorPicker(
              selectedColor: _selectedColor,
              onColorSelected: (color) => setState(() => _selectedColor = color),
            ),
          ),
          FilledButton(
            onPressed: () => _createItem(),
            child: Text('Create Item'),
          ),
        ],
      ),
    );
  }

  void _createItem() {
    // Use _selectedColor...
  }
}
```

---

## Quick Reference

### Common Imports
```dart
// For reusable widgets
import 'package:task/widgets/common/index.dart';

// For constants
import 'package:task/constants/app_constants.dart';

// For provider
import 'package:task/provider/task_provider.dart';
import 'package:provider/provider.dart';
```

### Common Patterns - One-Liners

```dart
// Show info dialog
await showInfoDialog(context: context, title: 'Success', message: 'Done!');

// Show confirmation
final ok = await showConfirmationDialog(
  context: context,
  title: 'Proceed?',
  content: 'Are you sure?',
  isDestructive: false,
);

// Use color picker
ColorPicker(selectedColor: _color, onColorSelected: (c) => setState(() => _color = c))

// Use icon picker  
IconPicker(selectedIcon: _icon, onIconSelected: (i) => setState(() => _icon = i))

// Use action group
BottomSheetActionGroup(actions: [
  (icon: Icons.edit, title: 'Edit', onTap: () {}, isDestructive: false, subtitle: null),
])
```

---

## File Summary

| File | Purpose | Lines | Status |
|------|---------|-------|--------|
| `app_constants.dart` | Central constants | 120 | ✅ New |
| `color_picker.dart` | Reusable color widget | 50 | ✅ New |
| `icon_picker.dart` | Reusable icon widget | 45 | ✅ New |
| `confirmation_dialog.dart` | Reusable confirmation | 75 | ✅ New |
| `bottom_sheet_action.dart` | Action items | 80 | ✅ New |
| `dialog_utils.dart` | Dialog helpers | 60 | ✅ New |
| `create_dialog.dart` | Task creation | 200 | ✓ Refactored |
| `create_folder_dialog.dart` | Folder creation | 127 | ✓ Refactored |
| `create_category_dialog.dart` | Category creation | 116 | ✓ Refactored |
| `task_bottom_sheet.dart` | Task options | 176 | ✓ Refactored |

---

**Version**: 1.0  
**Last Updated**: February 2026
**Status**: ✅ Production Ready
