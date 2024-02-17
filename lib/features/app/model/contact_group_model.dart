import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';

class ContactGroupModel {
  ContactGroupModel._();
  static final ContactGroupModel instance = ContactGroupModel._();

  Map<String, List<Contact>> groups = HashMap();

  void addGroup(String groupName, List<Contact> group) {
    groups.addAll({groupName: group});
  }

  void removeGroup(String groupName) {
    groups.remove(groupName);
  }
}
