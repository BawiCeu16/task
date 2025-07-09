import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:task/util/app_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:use_widgets/use_widgets.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final infoProvider = Provider.of<AppInfoProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        title: Text("About"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: CircleAvatar(
                          radius: 55,

                          backgroundImage: AssetImage(
                            "assets/images/play_store_512.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        infoProvider.packageName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        infoProvider.version,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    "       Effortlessly manage your tasks with this open-source app! Easily add, toggle, and delete tasks with a long-press. Enjoy an ad-free experience with all data stored locally—no internet needed. Available only on APKPure and GitHub for security. No unnecessary permissions, just simple, private task management with monthly updates for a seamless experience.",
                  ),
                  SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.5,
                            ),
                            children: const [
                              //Features
                              TextSpan(
                                text: 'Informations:\n',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Open-source',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' – Transparent and community-driven development.\n',
                              ),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Easy task management',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' – Add and mark tasks as complete with a toggle.\n',
                              ),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Quick deletion',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' – Long-press to remove tasks instantly.\n',
                              ),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Ad-free experience',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' – No distractions or interruptions.\n',
                              ),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Local storage',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' – Saves tasks offline; no internet required.\n',
                              ),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'No unnecessary permissions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' – Doesn’t access camera, contacts, or location etc.\n',
                              ),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Secure & private',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' – Your data stays on your device.\n',
                              ),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Monthly updates',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' – Regular bug fixes and UI improvements.\n',
                              ),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Official sources only',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' – Available exclusively on '),
                              TextSpan(
                                text: 'APKPure',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'GitHub',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' (Source Code).\n'),

                              TextSpan(
                                text: '• ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Lightweight & smooth',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' – Optimized for a user-friendly experience.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  /////////////////////////////////////////////////////////////////////////////////////////////
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            launchUrl(
                              Uri.parse("https://github.com/bawiceu16/task"),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(FlutterRemix.github_fill),
                                SizedBox(width: 5),
                                Text(
                                  "Open-Source project",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Card(
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    child: Text(
                      "privacy · policy",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                        "https://bawiceu16.github.io/task-privacy-and-policy-/",
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
