import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String name;
  final String phone;

  ContactModel({required this.name, required this.phone});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
      };

  static ContactModel fromJson(Map<String, dynamic> json) => ContactModel(
        name: json['name'],
        phone: json['phone'],
      );

  static Future<void> saveGroupToFirestore(
      String userId, String groupName, List<ContactModel> contacts) async {
    var groupsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('groups');

    // Convert each contact to a map
    List<Map<String, dynamic>> contactsMap =
        contacts.map((contact) => contact.toJson()).toList();

    // Create the group document with contacts
    await groupsCollection.add({
      'name': groupName,
      'contacts': contactsMap,
    });
  }
}
