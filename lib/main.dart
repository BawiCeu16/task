import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/util/task_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          splashFactory: NoSplash.splashFactory,
        ),
        home: HomePage(),
      ),
    );
  }
}
