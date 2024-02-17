import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:huddle/features/app/model/contact_group_model.dart';
import 'package:huddle/features/app/presentation/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../global/common/custom_app_bar.dart';
import '../widgets/global_bottom_app_bar_widget.dart';

class ContactsSelector extends StatefulWidget {
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
                      saveGroup(_groupName);
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

  void saveGroup(String groupName) {
    var groupModel = ContactGroupModel.instance;
    groupModel.groups[_groupName] = _selectedContacts;

    FirebaseFirestore.instance.collection("groups").add({"group": _groupName});

    FirebaseFirestore.instance
        .collection("group")
        .add({"contact": groupModel.groups[_groupName]});
    print(groupModel.groups.keys.toString());
  }
}
