import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:task/pages/about_page.dart';
import 'package:task/pages/theme_setting_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  void updateSystemOverlayStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    SystemChrome.setSystemUIOverlayStyle(
      brightness == Brightness.dark
          ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.black,
          )
          : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white,
          ),
    );
  }

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Settings",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 5),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: 0,
                      child: Column(
                        children: [
                          //Theme
                          ListTile(
                            title: Text("Theme"),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(Icons.palette),
                            ),
                            trailing: Icon(Icons.chevron_right),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: ThemeSettingsPage(),
                                  pageAnimationType: RightToLeftTransition(),
                                ),
                              );
                            },
                          ),
                          //
                          ListTile(
                            title: Text("Text Size"),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(Icons.text_fields),
                            ),
                            onTap:
                                () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("wait for next Update"),
                                      ),
                                    ),
                          ),

                          //
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            title: Text(
                              "Clear Data",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text("Delete Data?"),
                                      content: Row(
                                        children: [
                                          Text(
                                            "Warning! ",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                            ),
                                          ),
                                          Text(
                                            "Are you sure to delete All Data?",
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        FilledButton.tonal(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancle"),
                                        ),
                                        FilledButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                                ),
                                          ),
                                          onPressed: () {},
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  //links////////////////////////////////////////////////////////////////////////////////////
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "More",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 5),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),

                    child: Card(
                      elevation: 0,
                      child: Column(
                        children: [
                          //Github
                          ListTile(
                            title: Text("Github"),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(FontAwesomeIcons.github),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            onTap: () {
                              launchUrl(
                                Uri.parse("https://github.com/BawiCeu16"),
                              );
                            },
                          ),
                          //Email
                          ListTile(
                            title: Text("Email"),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(Icons.email),
                            ),
                            onTap: () {
                              launchUrl(
                                Uri.parse("mailto:bawiceu1428@gmail.com"),
                              );
                            },
                          ),
                          //About
                          ListTile(
                            title: Text("About"),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(Icons.info),
                            ),
                            trailing: Icon(Icons.chevron_right),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: InfoPage(),
                                  pageAnimationType: RightToLeftTransition(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
