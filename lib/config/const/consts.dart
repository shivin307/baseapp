import 'package:baseapp/local/local_storage.dart';
import 'package:baseapp/view/TestPage.dart';
import 'package:baseapp/view/desktop_page.dart';
import 'package:baseapp/view/login_page.dart';
import 'package:flutter/material.dart';

ThemeData kThemeData = ThemeData(
  primaryColor: Colors.green,
  primarySwatch: Colors.green,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  useMaterial3: true,
);

kSnackBar({required String msg, required BuildContext context}) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
}

Route<dynamic>? kRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => FutureBuilder(
          future: getIsLogin(key: 'isLogged'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error loading user login state');
              } else if (snapshot.data == true) {
                return const DesktopPage();
              } else {
                return LoginPage();
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      );
    case '/login':
      return MaterialPageRoute(builder: (_) => LoginPage());
    case '/desktop':
      return MaterialPageRoute(builder: (_) => const DesktopPage());
    case '/test':
      return MaterialPageRoute(builder: (_) =>  TestPage());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: const Center(
            child: Text('Error: Unknown route'),
          ),
        ),
      );
  }
}
