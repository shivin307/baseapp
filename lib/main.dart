import 'package:baseapp/config/const/consts.dart';
import 'package:baseapp/local/local_storage.dart'; // Import your shared preferences file
import 'package:baseapp/view/desktop_page.dart'; // Import your home page
import 'package:baseapp/view/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: kThemeData,
      initialRoute: '/desktop', // Set the initial route
      onGenerateRoute: kRoutes
    );
  }
}
