import 'package:flutter/material.dart';

class TopListTile extends StatelessWidget {
  final Widget? leading; // Good practice to make properties final
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  // 💡 FIX: Added leading and trailing to the constructor
  const TopListTile({
    super.key,
    this.leading, // Now configurable
    required this.title,
    this.subtitle,
    this.trailing, // Now configurable
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ... (rest of the build method remains the same)
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: Text(subtitle ?? ""),
        trailing: trailing,
        onTap: onTap,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
      ),
    );
  }
}
