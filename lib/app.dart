import 'package:flutter/material.dart';
import 'package:huddle/features/app/presentation/pages/contacts_selector.dart';
import 'package:huddle/features/app/presentation/pages/event_creation_page.dart';
import 'package:huddle/features/app/presentation/pages/group_viewer.dart';
import 'package:huddle/features/app/splash_screen/splash_screen.dart';
import 'package:huddle/features/app/presentation/pages/home_page.dart';
import 'package:huddle/features/app/presentation/pages/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF5D6D0),
            Color(0xFFD0EFF5),
          ],
        ),
      ),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Montserrat'),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/home": (context) => const HomePage(),
          "/login": (context) => const LoginPage(),
          "/groups": (context) => const GroupViewer(),
          "/events": (context) => const EventCreationPage(),
          "/contacts": (context) => const ContactsSelector(),
        },
        title: "Flutter Firebase",
        home: const SplashScreen(
          child: LoginPage(),
        ),
      ),
    );
  }
}
