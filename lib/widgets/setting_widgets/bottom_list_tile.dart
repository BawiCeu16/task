import 'package:flutter/material.dart';

class BottomListTile extends StatelessWidget {
  // Properties are already defined correctly
  final Widget?
  leading; // Changed to final, which is good practice for StatelessWidget
  final String title; // Changed to final
  final String? subtitle; // Changed to final
  final Widget? trailing; // Changed to final
  final VoidCallback? onTap; // Changed to final

  // 💡 FIX: Include leading and trailing in the constructor
  const BottomListTile({
    super.key,
    this.leading, // Added leading
    required this.title,
    this.subtitle,
    this.trailing, // Added trailing
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        // Added const for performance
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: ListTile(
        leading:
            leading, // This now references the value passed in the constructor
        title: Text(title),
        subtitle: Text(subtitle ?? ""),
        trailing:
            trailing, // This now references the value passed in the constructor
        onTap: onTap,
        shape: const RoundedRectangleBorder(
          // Added const
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
