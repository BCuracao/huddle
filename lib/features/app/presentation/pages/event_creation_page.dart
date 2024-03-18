import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:huddle/features/app/model/event_model.dart';
import 'package:huddle/features/app/presentation/widgets/form_container_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../global/common/custom_app_bar.dart';
import '../widgets/global_bottom_app_bar_widget.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  List<Contact> _availContacts = [];
  List<Contact> _selecContacts = [];
  late DateTime date;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _titleController.dispose();
  }

  _checkPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      // Load contacts if permission is granted
      _loadContacts();
    }
  }

  _loadContacts() async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      _availContacts = contacts.toList();
    });
  }

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createEvent(_selecContacts);
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.grey.shade600.withOpacity(0.5),
        elevation: 0,
        child: const Icon(
          Icons.done_outline_rounded,
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
      bottomNavigationBar: const GlobalBottomAppBarWidget(),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 200.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade600.withOpacity(0.25),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Create Event",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: FormContainerWidget(
                          hintText: "Event Name",
                          controller: _titleController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: TextField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  labelText: "DATE",
                                  filled: true,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.cyan),
                                  ),
                                ),
                                readOnly: true,
                                onTap: () {
                                  _selectDate();
                                },
                              ),
                            ),
                            // TODO: Contact group picker here
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: _availContacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            Contact contact = _availContacts[index];
                            return ListTile(
                              title: Text(
                                  contact.displayName ?? 'No name available'),
                              onTap: () {
                                print('Selected ${contact.displayName}');
                                setState(() {
                                  _selecContacts.add(contact);
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
        date = _picked;
      });
    }
  }

  void _createEvent(List<Contact> selecContacts) {
    String title = _titleController.text;
    EventModel event = EventModel(title, date, _selecContacts);
  }
}
