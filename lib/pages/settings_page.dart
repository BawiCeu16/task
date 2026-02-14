// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:task/pages/setting_screens/about_page.dart';
import 'package:task/pages/setting_screens/appearance_settings.dart';
import 'package:task/pages/setting_screens/list_settings.dart';
import 'package:task/pages/setting_screens/manage_all_page.dart';
import 'package:task/pages/setting_screens/backup_page.dart';
import 'package:task/widgets/setting_widgets/bottom_list_tile.dart';
import 'package:task/widgets/setting_widgets/middle_list_tile.dart';
import 'package:task/widgets/setting_widgets/top_list_tile.dart';
import 'package:task/widgets/icon_mapper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        animateColor: true,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 5),
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            TopListTile(
              leading: Icon(remixIcon(Icons.palette_outlined)),
              title: "Appearance",
              subtitle: "Accent colors and Theme mode",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppearanceSettings(),
                ),
              ),
            ),

            const SizedBox(height: 3),

            MiddleListTile(
              leading: Icon(remixIcon(Icons.list)),
              title: "List",
              subtitle: "Sort etc.",

              // onTap: () {}, // keepable placeholder
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const ListSettings()),
              ),
            ),

            const SizedBox(height: 3),

            MiddleListTile(
              leading: Icon(remixIcon(Icons.edit_note)),
              title: "Manage",
              subtitle: "Folders and Categories (delete / clear / manage)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const ManageAllPage()),
              ),
            ),

            const SizedBox(height: 3),

            // Backup & Restore
            BottomListTile(
              leading: Icon(remixIcon(Icons.settings_backup_restore_outlined)),
              title: "Backup & Restore",
              subtitle: "Export or import tasks (JSON)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const BackupPage()),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "Contact & Info",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),

            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(remixIcon(Icons.info_outline)),
                title: const Text("About"),
                subtitle: const Text("Informations and License"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                ),
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
