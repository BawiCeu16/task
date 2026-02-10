import 'package:flutter/material.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/app_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<AppInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("About App"),
        animateColor: true,
        scrolledUnderElevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- App Header ---
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),

                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("assets/icons/icon.png"),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appInfo.appName.isEmpty
                                    ? "App Name"
                                    : appInfo.appName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),
                              Text(
                                appInfo.version.isEmpty
                                    ? "Loading..."
                                    : appInfo.version,
                              ),

                              Text(
                                appInfo.packageName.isEmpty
                                    ? "Package name"
                                    : appInfo.packageName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  "This app is built to provide an easy and smooth experience for managing your tasks. The developer focused on a clean, minimal UI designed for clarity and comfort. Every part of the interface is simple, modern, and distraction-free, helping you stay organized with ease and efficiency.",

                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     width: 2,
                    //     color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    //   ),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Developer Section
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              top: 10,
                              bottom: 5,
                            ),
                            child: Text(
                              'Developer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          _buildContributorTile(
                            'BawiCeu',
                            'https://bawiceu16.github.io/bawiceu.dev/',
                            Icon(remixIcon(Icons.person)),
                          ),
                          const SizedBox(height: 5.0),

                          Divider(),

                          const SizedBox(height: 5.0),

                          // Connect Section
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 15,
                              bottom: 5,
                            ),
                            child: Text(
                              'Connect',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildContributorTile(
                            'Follow on Github',
                            'https://github.com/BawiCeu16',
                            Icon(remixIcon(Icons.link)),
                          ),
                          _buildContributorTile(
                            'Visit Website',
                            'https://bawiceu16.github.io/bawiceu.dev/',
                            Icon(remixIcon(Icons.language)),
                          ),
                          const SizedBox(height: 5.0),
                          const Divider(),
                          const SizedBox(height: 5.0),

                          // GitHub Repo
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            leading: Icon(remixIcon(Icons.code)),
                            title: const Text('Source Code'),
                            onTap: () async {
                              launchUrl(
                                Uri.parse('https://github.com/BawiCeu16/task'),
                              );
                            },
                          ),
                          // Privacy Policy
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(100),
                            ),
                            leading: Icon(remixIcon(Icons.shield_outlined)),
                            title: Text('Privacy Policy'),
                            onTap: () async {
                              launchUrl(
                                Uri.parse(
                                  'https://bawiceu16.github.io/task-privacy-and-policy-/',
                                ),
                              );
                            },
                          ),
                          // Open Source Licenses
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(100),
                            ),
                            leading: Icon(remixIcon(Icons.article)),
                            title: Text('OpenSource Licenses'),
                            onTap: () => showLicensePage(
                              context: context,
                              applicationName: appInfo.appName,
                              applicationVersion: appInfo.version,
                              applicationLegalese: '© 2025 Nix',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// --- New version flag ---
                if (appInfo.isNewVersion)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange.withOpacity(0.2),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            remixIcon(Icons.new_releases),
                            color: Colors.orange,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "A new version was detected on this device.",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContributorTile(String name, String url, Widget icon) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(100.0),
      ),
      leading: icon,
      title: Text(name),
      onTap: () async {
        await launchUrl(Uri.parse(url));
      },
    );
  }
}
