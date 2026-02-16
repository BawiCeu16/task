/// Application-wide constants for consistent styling and values
import 'package:flutter/material.dart';

class AppConstants {
  // ========== Border Radius Constants ==========
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 20.0;
  static const double borderRadiusRound = 100.0;

  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(borderRadiusLarge),
  );
  static const BorderRadius dialogBorderRadius = BorderRadius.all(
    Radius.circular(borderRadiusXLarge),
  );

  // Top-only border radius
  static const BorderRadius topBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
  );

  // Bottom-only border radius
  static const BorderRadius bottomBorderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );

  // Middle border radius (for middle items in a list)
  static const BorderRadius middleBorderRadius = BorderRadius.all(
    Radius.circular(5),
  );

  // ========== Padding Constants ==========
  static const EdgeInsets paddingSmall = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(12.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(16.0);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(20.0);

  static const EdgeInsets horizontalPaddingMedium = EdgeInsets.symmetric(
    horizontal: 16.0,
  );
  static const EdgeInsets horizontalPaddingLarge = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const EdgeInsets verticalPaddingMedium = EdgeInsets.symmetric(
    vertical: 12.0,
  );

  // ========== Spacing Constants ==========
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;

  // ========== Color Palette ==========
  static const List<int?> availableColors = [
    null, // No color
    0xFFFF0000, // Red
    0xFFFF6600, // Orange
    0xFFCCFF00, // Yellow
    0xFF00CC00, // Green
    0xFF0000FF, // Blue
    0xFF4400FF, // Indigo
    0xFF9900FF, // Purple
    0xFFFF0099, // Pink
    0xFF8B4513, // Brown
    0xFF808080, // Grey
  ];

  // ========== Icon Picker Size ==========
  static const double iconPickerSize = 24.0;
  static const double iconPickerContainerSize = 50.0;
  static const double iconPickerPadding = 8.0;

  // ========== Color Picker Size ==========
  static const double colorPickerSize = 32.0;
  static const double colorPickerMargin = 4.0;
  static const double colorPickerBorderWidth = 3.0;

  // ========== List Tile Sizing ==========
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const double listTileContentPaddedHeight = 12.0;

  // ========== Dialog Sizing ==========
  static const double dialogWidth = 400.0;
  static const double dialogMaxHeight = 600.0;

  // ========== Icon Codes (for MaterialIcons remix) ==========
  static const IconData iconTaskAdd = Icons.add;
  static const IconData iconTaskEdit = Icons.edit;
  static const IconData iconTaskDelete = Icons.delete;
  static const IconData iconTaskDone = Icons.check_circle;
  static const IconData iconTaskTodo = Icons.circle_outlined;
  static const IconData iconFolderCreate = Icons.create_new_folder;
  static const IconData iconCategoryAdd = Icons.add;
  static const IconData iconCategoryDefault = Icons.category_outlined;
  static const IconData iconInfo = Icons.info;
  static const IconData iconClose = Icons.close;
  static const IconData iconChevronRight = Icons.chevron_right;

  // ========== Animation Durations ==========
  static const Duration opacityAnimationDuration = Duration(milliseconds: 220);
  static const Duration fadeAnimationDuration = Duration(milliseconds: 300);

  // ========== List of Default Icons for Folders ==========
  static const List<Map<String, IconData>> defaultFolderIcons = [
    {'Folder': Icons.folder},
    {'Work': Icons.work},
    {'Home': Icons.home},
    {'Person': Icons.person},
    {'Settings': Icons.settings},
    {'Heart': Icons.favorite},
    {'Star': Icons.star},
    {'Music': Icons.music_note},
  ];

  // ========== Text Constants ==========
  static const String labelNoFolder = 'No folder';
  static const String labelNoCategory = 'No category';
  static const String labelNone = 'None';

  // ========== Dialog Text Constants ==========
  static const String dialogTitleCreateTask = 'Create Task';
  static const String dialogTitleEditTask = 'Edit Task';
  static const String dialogTitleCreateFolder = 'Create folder';
  static const String dialogTitleEditFolder = 'Edit Folder';
  static const String dialogTitleCreateCategory = 'Create Category';
  static const String dialogTitleEditCategory = 'Edit Category';
  static const String dialogTitleDeleteConfirm = 'Confirm Delete';

  static const String buttonCancel = 'Cancel';
  static const String buttonCreate = 'Create';
  static const String buttonSave = 'Save';
  static const String buttonDelete = 'Delete';
  static const String buttonClose = 'Close';
  static const String buttonConfirm = 'Confirm';

  // ========== Suggestion Messages ==========
  static const String msgNoFolder = "There's No Folders";
  static const String msgNoCategory = "There's No Categories";
  static const String msgAddNewFolder = "Add New Folder";
  static const String msgAddNewCategory = "Add New Categories";

  // ========== Page Titles ==========
  static const String pageTitleHome = 'Tasks';
  static const String pageTitleSearch = 'Search';
  static const String pageTitleFolders = 'Folders';
  static const String pageTitleCategories = 'Categories';
  static const String pageTitleSettings = 'Settings';
  static const String pageTitleManageAll = 'Manage';
  static const String pageTitleManageTasks = 'Manage Tasks';
  static const String pageTitleManageFolders = 'Manage Folders';
  static const String pageTitleManageCategories = 'Manage Categories';
  static const String pageTitleAppearance = 'Appearance';
  static const String pageTitleAbout = 'About';
  static const String pageTitleBackup = 'Backup';

  // ========== Empty State Messages ==========
  static const String emptyStateTitleNoTasks = "No tasks yet";
  static const String emptyStateSubtitleNoTasks =
      "Create a new task to get started";
  static const String emptyStateTitleNoFolders = "There's No Folders";
  static const String emptyStateSubtitleNoFolders =
      "Create a new folder to organize your tasks";
  static const String emptyStateTitleNoCategories = "There's No Categories";
  static const String emptyStateSubtitleNoCategories =
      "Create a new category to tag your tasks";

  // ========== Confirmation Messages ==========
  static const String confirmDeleteTask = "Delete this task?";
  static const String confirmDeleteMultipleTasks = "Delete all selected tasks?";
  static const String confirmDeleteFolder = "Delete this folder and its tasks?";
  static const String confirmDeleteAllFolders = "Delete all folders?";
  static const String confirmDeleteCategory = "Delete this category?";
  static const String confirmDeleteAllCategories = "Delete all categories?";
  static const String confirmClearAllTasks =
      "Clear all tasks? This action cannot be undone.";
  static const String confirmDeletionCannotUndo =
      "This action cannot be undone.";

  // ========== Action Messages ==========
  static const String actionRename = 'Rename';
  static const String actionEdit = 'Edit';
  static const String actionDelete = 'Delete';
  static const String actionDeleteAll = 'Delete All';
  static const String actionClearAll = 'Clear All';
  static const String actionExport = 'Export';
  static const String actionImport = 'Import';
  static const String actionSelectIcon = 'Select Icon or Image';
  static const String actionSelectColor = 'Select Color';
  static const String actionAddNewFolder = 'Add New Folder';
  static const String actionAddNewCategory = 'Add New Category';
  static const String actionPickImage = 'Pick Image from Gallery';

  // ========== Success/Error Messages ==========
  static const String msgSuccess = 'Success!';
  static const String msgError = 'Error occurred';
  static const String msgTaskCreated = 'Task created successfully';
  static const String msgTaskUpdated = 'Task updated successfully';
  static const String msgTaskDeleted = 'Task deleted';
  static const String msgFolderCreated = 'Folder created successfully';
  static const String msgFolderDeleted = 'Folder deleted';
  static const String msgCategoryCreated = 'Category created successfully';
  static const String msgCategoryDeleted = 'Category deleted';
  static const String msgRenamedTo = 'Renamed to';

  // ========== Status Labels ==========
  static const String statusCompleted = 'Completed';
  static const String statusIncomplete = 'Incomplete';
  static const String statusNoFolder = 'No folder';
  static const String statusNoCategory = 'No category';
  static const String statusAllTasks = 'All Tasks';
  static const String statusCompletedTasks = 'Completed Tasks';
  static const String statusIncompleteTasks = 'Incomplete Tasks';

  // ========== Dialog Titles ==========
  static const String dialogTitleSelectIcon = 'Select Icon';
  static const String dialogTitleSelectColor = 'Select Color';
  static const String dialogTitleResetTheme = 'Reset theme?';
  static const String dialogTitleDeleteAllTasks = 'Clear all tasks?';
  static const String dialogTitleAlsoDeleteTasks = 'Also delete tasks?';
  static const String dialogTitleKeepTasks = 'Keep tasks (unset folder)';
  static const String dialogTitleDeleteTasks = 'Delete tasks too';
}
