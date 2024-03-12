import 'dart:ui';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class GlobalBottomAppBarWidget extends StatefulWidget {
  const GlobalBottomAppBarWidget({super.key});

  @override
  State<GlobalBottomAppBarWidget> createState() =>
      _GlobalBottomAppBarWidgetState();
}

class _GlobalBottomAppBarWidgetState extends State<GlobalBottomAppBarWidget> {
  List<Contact> userGroup = [];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.0,
      clipBehavior: Clip.antiAlias,
      color: Colors.grey.shade600.withOpacity(0.5),
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/home");
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.groups_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name == "/groups") {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushNamed("/groups");
                  }
                },
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.group_add_outlined,
                      color: Colors.white,
                    ),
                    onPressed: showContacts,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showContacts() async {
    if (ModalRoute.of(context)?.settings.name == "/contacts") {
      Navigator.of(context).pop();
    } else {
      final List<Contact>? selectedContacts =
          await Navigator.of(context).pushNamed("/contacts") as List<Contact>?;
      if (selectedContacts != null) {
        setState(() {
          userGroup = selectedContacts;
          printSelectedContacts(); // Print selected contacts to console
        });
      }
    }
  }

  // ! Only for debugging
  void printSelectedContacts() {
    userGroup.forEach((contact) {
      print('Selected Contact: ${contact.displayName}');
    });
  }
}
