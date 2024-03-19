import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huddle/features/app/presentation/pages/sign_up_page.dart';
import 'package:huddle/features/app/presentation/widgets/form_container_widget.dart';
import 'package:huddle/global/common/toast.dart';

import '../../model/group_model.dart';
import '../../user_auth/firebase_auth_implementation/firebase_auth_services.dart';

final groupModelInstance = GroupModel.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation = Tween<double>(begin: 0, end: 35 * 0.0174533)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(const Duration(seconds: 2), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Jump ",
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 5),
                    child: Transform.rotate(
                      angle: _animation.value,
                      child: Text(
                        "In ..",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.deepOrange.shade400,
                          shadows: <Shadow>[
                            Shadow(
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 5.0,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 185.0),
              child: Container(
                height: 130,
                width: 130,
                alignment: Alignment.topRight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topRight,
                    fit: BoxFit.contain,
                    image: AssetImage("assets/images/login_background_3.png"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            const SizedBox(height: 10),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _signIn();
              },
              child: !_isLoading
                  ? Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(250, 255, 171, 145),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.lightGreen.shade400,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.lightGreen.shade400,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                      ((route) => false),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    groupModelInstance.getUserGroups(user!.uid).then((groupDocs) {
      for (var doc in groupDocs) {
        groupModelInstance.groupData = doc.data();
      }
    }).catchError((error) {
      print("Error getting groups:  + $error");
    });

    showToast(message: "User is successfully signedIn");
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, "/home");

    setState(() {
      _isLoading = false;
    });
  }
}
