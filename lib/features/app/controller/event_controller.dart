import 'package:huddle/features/app/model/event_model.dart';

class EventController {
  late List<EventModel> events;

  void addEvent(EventModel event) {
    events.add(event);
  }

  void removeEvent(EventModel event) {
    events.remove(event);
  }

  List<EventModel> getEvents() {
    return events;
  }
}
