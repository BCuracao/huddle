import 'dart:ui';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huddle/features/app/presentation/pages/event_creation_page.dart';
import 'package:huddle/features/app/presentation/widgets/global_bottom_app_bar_widget.dart';
import 'package:huddle/global/common/custom_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../global/common/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> _contacts = [];
  List<Contact> userGroup = [];

  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  TextEditingController _eventTitleController = TextEditingController();

  @override
  void dispose() {
    _eventTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const EventCreationPage(),
              ),
              ((route) => false),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.grey.shade600.withOpacity(0.5),
          elevation: 0,
          child: const Icon(
            Icons.event,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          leading: Icon(
            Icons.home,
            color: Colors.grey.shade600.withOpacity(0.5),
          ),
          showActionIcon: true,
        ),
        bottomNavigationBar: const GlobalBottomAppBarWidget(),
        body: Container(
          margin: const EdgeInsets.only(top: 120, left: 20),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "New Events",
                style: TextStyle(
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed),
              ),
              SizedBox(
                height: 30,
              ),

              /*
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, "/login");
                      showToast(message: "Successfully signed out");
                    },
                    child: Container(
                      height: 45,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Out",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  */
            ],
          ),
        ));
  }

  Future<void> _askPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      // Permission is granted. Proceed to fetch contacts.
      var contacts = await ContactsService.getContacts();

      for (Contact contact in _contacts) {
        print(contact.toString());
      }
      setState(() {
        _contacts = contacts.toList();
        print("number of contacts: ");
        print(_contacts.length);
      });
    }
  }
}
