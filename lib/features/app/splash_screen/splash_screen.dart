import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showSecondPart = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Huddle",
                    textStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                    speed: const Duration(milliseconds: 250),
                  ),
                ],
                onFinished: () {
                  setState(() {
                    _showSecondPart = true;
                  });
                },
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 0),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
/*               if (_showSecondPart)
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "Up!",
                      textStyle: TextStyle(
                          color: Colors
                              .deepOrange.shade400, // Different color for "Up!"
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat"),
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 0),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ), */
            ],
          ),
        ],
      ),
    );
  }
}
