import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task/pages/info_page.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final githubUri = Uri.parse("https://github.com/BawiCeu16");
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  //Theme
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),

                    child: ListTile(
                      title: Text("Theme"),
                      leading: Icon(Icons.palette),
                      trailing: Icon(Icons.chevron_right),
                      onTap:
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("wait for next Update")),
                          ),
                    ),
                  ),

                  //
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(15),
                        // topRight: Radius.circular(15),
                      ),
                    ),

                    child: ListTile(
                      title: Text("Text Size"),
                      leading: Icon(Icons.text_fields),
                      onTap:
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("wait for next Update")),
                          ),
                    ),
                  ),

                  //
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),

                    child: ListTile(
                      title: Text(
                        "Clear Data",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      leading: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onTap:
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("wait for next Update")),
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

                  //Github
                  Link(
                    uri: githubUri,
                    target: LinkTarget.defaultTarget,

                    builder: (context, openLink) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),

                        child: ListTile(
                          title: Text("Github"),
                          leading: Icon(FontAwesomeIcons.github),
                          onTap: openLink,
                        ),
                      );
                    },
                  ),
                  //Email
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(15),
                        // topRight: Radius.circular(15),
                      ),
                    ),

                    child: ListTile(
                      title: Text("Email"),
                      leading: Icon(Icons.email),
                      onTap: () {
                        launchUrl(Uri.parse("mailto:bawiceu1428@gmail.com"));
                      },
                    ),
                  ),
                  //Info
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),

                    child: ListTile(
                      title: Text("Info"),
                      leading: Icon(Icons.info),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InfoPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
