import 'package:flutter/material.dart';
import 'package:huddle/features/app/model/contact_group_model.dart';
import 'package:huddle/global/common/custom_app_bar.dart';

import '../widgets/global_bottom_app_bar_widget.dart';
import 'event_creation_page.dart';

class GroupViewer extends StatefulWidget {
  const GroupViewer({super.key});

  @override
  State<GroupViewer> createState() => _GroupViewerState();
}

class _GroupViewerState extends State<GroupViewer> {
  ContactGroupModel model = ContactGroupModel.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const EventCreationPage(),
            ),
            ((route) => false),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.grey.shade600.withOpacity(0.5),
        elevation: 12,
        child: const Icon(
          Icons.edit_note_rounded,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromRGBO(248, 250, 249, 1.0),
      appBar: const CustomAppBar(
        title: "Custom App Bar",
        leading: Icon(
          Icons.home,
          color: Colors.white,
        ),
        showActionIcon: true,
      ),
      bottomNavigationBar: const GlobalBottomAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: model.groups.length,
          itemBuilder: (context, index) {
            String groupName = model.groups.keys.elementAt(index);
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              height: 50,
              child: GestureDetector(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('This is a fullscreen dialog.'),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    groupName,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
