import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactAccess {
  Future<void> requestContactPermission() async {
    final status = await Permission.contacts.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Contacts permission denied');
    }
  }

  Future<List<Contact>> getContacts() async {
    final permissionStatus = await Permission.contacts.status;
    if (permissionStatus != PermissionStatus.granted) {
      throw Exception('Contacts permission denied');
    }

    final contacts = await ContactsService.getContacts();
    return contacts;
  }
}
