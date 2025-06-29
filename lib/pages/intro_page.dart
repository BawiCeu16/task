// import 'package:flutter/material.dart';
// import 'package:introduction_slider/introduction_slider.dart';
// import 'package:task/pages/home_page.dart';
// import 'package:url_launcher/url_launcher.dart';

// class IntroPage extends StatelessWidget {
//   const IntroPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return IntroductionSlider(
//       physics: AlwaysScrollableScrollPhysics(),
//       dotIndicator: DotIndicator(
//         selectedColor: Theme.of(context).colorScheme.primary,
//       ),
//       initialPage: 0,
//       scrollDirection: Axis.horizontal,
//       showStatusBar: true,
//       key: key,

//       back: Back(
//         child: Text("Previous"),
//         animationDuration: Duration(milliseconds: 200),
//         curve: Curves.easeOutCubic,
//       ),
//       next: Next(
//         style: ButtonStyle(),
//         child: Text("Next"),
//         animationDuration: Duration(milliseconds: 200),
//         curve: Curves.easeOutCubic,
//       ),
//       done: Done(
//         child: Text("Done"),

//         animationDuration: Duration(milliseconds: 200),
//         curve: Curves.easeOutCubic,

//         home: HomePage(),
//       ),
//       items: [
//         IntroductionSliderItem(
//           backgroundColor: Theme.of(context).colorScheme.onPrimary,
//           logo: FlutterLogo(),
//           title: Text(
//             "Welcome to Task app",
//             style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text("clean and simple UI"),
//           ),
//         ),
//         IntroductionSliderItem(
//           backgroundColor: Theme.of(context).colorScheme.onPrimary,
//           logo: FlutterLogo(),
//           title: Text(
//             "Ad free and No Permission requred",
//             style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               "        All your tasks and settings are saved locally on your device and are not backed up on any cloud service.",
//             ),
//           ),
//         ),
//         IntroductionSliderItem(
//           backgroundColor: Theme.of(context).colorScheme.onPrimary,
//           logo: FlutterLogo(),
//           title: Text(
//             "Open-Source Project",
//             style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Wrap(
//               children: [
//                 Text(
//                   "        This app was Open_source project and free to use. to check-out project",
//                 ),
//                 Center(
//                   child: InkWell(
//                     onTap: () {
//                       launchUrl(Uri.parse("https://github.com/BawiCeu16/task"));
//                     },
//                     child: Text(
//                       "click here",
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
