import 'package:flutter/material.dart';
import 'package:huddle/features/app/splash_screen/splash_screen.dart';
import 'package:huddle/features/app/presentation/pages/home_page.dart';
import 'package:huddle/features/app/presentation/pages/login_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/home": (context) => const HomePage(),
        "/login": (context) => const LoginPage(),
      },
      title: "Flutter Firebase",
      home: const SplashScreen(
        child: LoginPage(),
      ),
    );
  }
}
