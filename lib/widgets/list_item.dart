import 'package:flutter/material.dart';
import 'package:task/widgets/icon_mapper.dart';

class MyListItem extends StatelessWidget {
  final String title;
  final bool isDone;
  final String date;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MyListItem({
    super.key,
    required this.title,
    required this.isDone,
    required this.date,
    this.onTap,
    this.onLongPress,
    this.color,
  });

  final int? color;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: isDone ? 0.5 : 1.0,
      child: Card(
        color: color != null ? Color(color!) : null,
        elevation: 0,
        // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: EdgeInsets.all(0),
        shape: Theme.of(context).cardTheme.shape,
        child: ListTile(
          shape: Theme.of(context).cardTheme.shape,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text(
            title,
            style: TextStyle(
              decoration: isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: isDone
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                  : null,
            ),
          ),
          subtitle: _buildDateSubtitle(),
          trailing: Icon(
            isDone
                ? remixIcon(Icons.check_circle)
                : remixIcon(Icons.circle_outlined),
            color: isDone ? Colors.green : null,
          ),
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }

  Widget? _buildDateSubtitle() {
    if (date.isEmpty) return null;
    try {
      final dt = DateTime.parse(date).toLocal();
      final dateShort =
          "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
      return Text(dateShort);
    } catch (_) {
      return Text(date);
    }
  }
}
