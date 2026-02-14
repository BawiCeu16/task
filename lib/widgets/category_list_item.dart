import 'package:flutter/material.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:task/pages/main_pages/category_detail_page.dart';
import 'package:task/utils/category_icons_helper.dart';

/// Reusable widget for displaying a category list item with icon and task count
class CategoryListItem extends StatelessWidget {
  final String categoryName;
  final int? iconCode; // Kept for backward compatibility but not used
  final int taskCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CategoryListItem({
    super.key,
    required this.categoryName,
    this.iconCode,
    required this.taskCount,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Use CategoryIconsHelper to get const icon based on category name
    final iconData = CategoryIconsHelper.getIconForCategory(categoryName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Theme.of(context).colorScheme.primary),
          ),
          title: Text(
            categoryName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('$taskCount task${taskCount == 1 ? '' : 's'}'),
          trailing: Icon(remixIcon(Icons.chevron_right)),
          onTap:
              onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CategoryDetailPage(categoryName: categoryName),
                  ),
                );
              },
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
