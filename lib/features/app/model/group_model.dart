import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';

import '../presentation/pages/contacts_selector.dart';

class GroupModel {
  static final GroupModel instance = GroupModel();

  Map<String, List<Contact>> groups = HashMap();
  Map<String, dynamic> groupData = HashMap();

  void addGroup(String groupName, List<Contact> group) {
    groups.addAll({groupName: group});
  }

  void removeGroup(String groupName) {
    groups.remove(groupName);
  }

  late String userId = currentUserRef!.uid;
  late String groupId = getGroupId(userId);

  String getGroupId(String id) => firestoreInstance
      .collection("users")
      .doc(id)
      .collection("groups")
      .doc()
      .id;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserGroups(
      String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the user's groups subcollection
    QuerySnapshot<Map<String, dynamic>> groupsSnapshot = await firestore
        .collection("users")
        .doc(userId)
        .collection("groups")
        .get();

    return groupsSnapshot.docs;
  }

  dynamic getGroupContacts() => firestoreInstance
      .collection("users")
      .doc(userId)
      .collection("groups")
      .doc(groupId)
      .collection("contacts");

  Future<int?> getGroupCount() {
    return firestoreInstance
        .collection("users")
        .doc(userId)
        .collection("groups")
        .count()
        .get()
        .then((value) => value.count);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getGroupNames() =>
      firestoreInstance
          .collection("users")
          .doc(userId)
          .collection("groups")
          .get()
          .then((value) => value.docs);
}

class PrintGoupInformation {
  static printGroupCount() {}
}
