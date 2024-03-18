import 'package:contacts_service/contacts_service.dart';

class EventModel {
  String titel = "";
  late DateTime date;
  late List<Contact> attendees;
  List<EventModel> events = [];

  EventModel(this.titel, this.date, this.attendees);
}
