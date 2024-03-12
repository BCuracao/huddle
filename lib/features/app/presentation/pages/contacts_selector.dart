import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huddle/features/app/model/group_model.dart';
import 'package:huddle/features/app/presentation/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../global/common/custom_app_bar.dart';
import '../widgets/global_bottom_app_bar_widget.dart';

// Retrieve FirebaseFirestore instance
final firestoreInstance = FirebaseFirestore.instance;

// Retrieve Reference of current user
final currentUserRef = FirebaseAuth.instance.currentUser;

final groupModelInstance = GroupModel.instance;

class ContactsSelector extends StatefulWidget {
  const ContactsSelector({super.key});

  @override
  _ContactsSelectorState createState() => _ContactsSelectorState();
}

class _ContactsSelectorState extends State<ContactsSelector> {
  List<Contact> _contacts = [];
  final List<Contact> _selectedContacts = [];

  late String _groupName;

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission == PermissionStatus.granted) {
      List<Contact> contacts = (await ContactsService.getContacts()).toList();
      setState(() {
        _contacts = contacts;
      });
    } else {
      // Handle permission denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show input field for group name
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Enter Group Name'),
                content: TextField(
                  onChanged: (value) => _groupName = value,
                ),
                actions: [
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      // Save group with the provided name
                      //saveGroup(_groupName);

                      //onConfirmGroupCreation(
                      //_groupName, _selectedContacts.cast<ContactModel>());
                      storeGroupInformation();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                    },
                  ),
                ],
              );
            },
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.grey.shade600.withOpacity(0.5),
        elevation: 12,
        child: const Icon(
          Icons.check_circle_outline_outlined,
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
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts[index];
          return SingleChildScrollView(
            child: ListTile(
              title: Text(contact.displayName ?? ''),
              trailing: Checkbox(
                value: _selectedContacts.contains(contact),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedContacts.add(contact);
                    } else {
                      _selectedContacts.remove(contact);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const GlobalBottomAppBarWidget(),
    );
  }

  Future<void> storeGroupInformation() async {
    groupModelInstance.addGroup(_groupName, _selectedContacts);

    String userId = currentUserRef!.uid;
    firestoreInstance.collection("users").doc(userId);

    String groupId = firestoreInstance
        .collection("users")
        .doc(userId)
        .collection("groups")
        .doc()
        .id;

    firestoreInstance
        .collection("users")
        .doc(userId)
        .collection("groups")
        .doc(groupId)
        .set({"groupName:": _groupName});

    for (int i = 0; i < _selectedContacts.length; i++) {
      firestoreInstance
          .collection("users")
          .doc(userId)
          .collection("groups")
          .doc(groupId)
          .collection("contacts")
          .add({"contact": _selectedContacts[i].displayName});
    }
  }
}
