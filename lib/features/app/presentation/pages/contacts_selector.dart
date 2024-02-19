import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huddle/features/app/model/contact_model.dart';
import 'package:huddle/features/app/model/group_model.dart';
import 'package:huddle/features/app/presentation/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../global/common/custom_app_bar.dart';
import '../widgets/global_bottom_app_bar_widget.dart';

// Retrieve FirebaseFirestore instance
final FIREBASE_FIRESTORE = FirebaseFirestore.instance;

// Retrieve GroupModel instance
final GROUP_MODEL = GroupModel.instance;

// Retrieve Reference of current user
final CURRENT_USER = FirebaseAuth.instance.currentUser;

// Firestore collection references
final FS_USERS_COLLECTION = FIREBASE_FIRESTORE.collection("users");

class ContactsSelector extends StatefulWidget {
  const ContactsSelector({super.key});

  @override
  _ContactsSelectorState createState() => _ContactsSelectorState();
}

class _ContactsSelectorState extends State<ContactsSelector> {
  List<Contact> _contacts = [];
  List<Contact> _selectedContacts = [];

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
                      storeUserInformation();
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

  Future<void> storeUserInformation() async {
    FIREBASE_FIRESTORE
        .collection("users")
        .doc(CURRENT_USER!.uid)
        .set({"email": CURRENT_USER!.email, "name": CURRENT_USER!.displayName})
        .then((_) => {
              FIREBASE_FIRESTORE
                  .collection("users")
                  .doc(CURRENT_USER!.uid)
                  .collection("groups")
            })
        .then((_) => {
              //TODO: This is fucked. Creates "group" collection in the wrong location
              FIREBASE_FIRESTORE
                  .collection("users")
                  .doc(CURRENT_USER!.uid)
                  .collection("groups")
                  .doc("group")
                  .collection(_groupName)
                  .add({"contacts": "test"})
            });

    print("stored user data in Firestore");
  }

/*
  void saveGroup(String groupName) {
    var groupModel = GroupModel.instance;
    groupModel.groups[_groupName] = _selectedContacts;

    FirebaseFirestore.instance.collection("groups").add({"group": _groupName});

    FirebaseFirestore.instance
        .collection("user")
        .add(_contacts[0].familyName as Map<String, dynamic>);

    FirebaseFirestore.instance
        .collection("group")
        .add({"contact": groupModel.groups[_groupName]});
    print(groupModel.groups.keys.toString());
  }

  void onConfirmGroupCreation(
      String groupName, List<ContactModel> selectedContacts) {
    String userId =
        "user_id_from_auth_system"; // Replace with actual user ID from your auth system
    ContactModel.saveGroupToFirestore(userId, groupName, selectedContacts)
        .then((_) {
      print("Group saved successfully");
    }).catchError((error) {
      print("Failed to save group: $error");
    });
  }
  */
}
