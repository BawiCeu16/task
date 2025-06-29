import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: AssetImage(
                          "assets/play_store_512.png",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        "task",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "1.1.1",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 20),
                  child: Text(
                    "       This task app lets you add tasks easily and toggle them to mark as complete. Long-press to delete tasks quickly. Enjoy an ad-free experience with all your tasks save in local storage (no internet required).",

                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 20),
                  child: Text(
                    "        App is only officially available on APKPure—downloads from other sources are not legitimate, and we take no responsibility for them.Additionally, this app does not request any special permissions (such as camera, contacts, or location) since it only uses local storage to save your tasks, ensuring your privacy and security.",

                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 20),
                  child: Text(
                    "       The developer releases monthly updates to fix bugs and improve the UI, providing a smooth and user-friendly experience. Stay organized effortlessly.",

                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 20),
                  child: Center(
                    child: Text(
                      "This app is now Open-Source",

                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
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
                    "privacy . policy",
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
    );
  }
}
