import 'package:contacts_service/contacts_service.dart';

class EventModel {
  String titel = "";
  late DateTime date;
  late DateTime expirationDate;
  late List<Contact> attendees;

  EventModel(this.titel, this.date, this.expirationDate, this.attendees);
}
