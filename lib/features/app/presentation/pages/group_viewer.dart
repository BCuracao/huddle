import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddle/features/app/model/group_model.dart';
import 'package:huddle/features/app/presentation/pages/contacts_selector.dart';
import 'package:huddle/global/common/custom_app_bar.dart';

import '../widgets/global_bottom_app_bar_widget.dart';
import 'event_creation_page.dart';

// Retrieve FirebaseFirestore instance
final firestoreInstance = FirebaseFirestore.instance;

final groupModelInstance = GroupModel.instance;

class GroupViewer extends StatefulWidget {
  const GroupViewer({super.key});

  @override
  State<GroupViewer> createState() => _GroupViewerState();
}

class _GroupViewerState extends State<GroupViewer> {
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
        child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: groupModelInstance.getUserGroups(currentUserRef!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> group = snapshot.data![index].data();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25),
                      image: const DecorationImage(
                          image: ExactAssetImage(
                              "assets/images/group_background_crop_1.png"),
                          fit: BoxFit.fill,
                          opacity: 0.35),
                    ),
                    child: ListTile(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Group Details'),
                                const SizedBox(height: 15),
                                Text(group
                                    .toString()), // Display group details here
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      //title: Text(group['groupName'] ??
                      //    'Unnamed Group'), // Assuming 'name' is a key in your group map
                      title: Text(
                        group.values.elementAt(0),
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> renderUserGroups(String uid) async {
    Map<String, dynamic> groupData = HashMap();
    Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> Function(
        String userId) groups = groupModelInstance.getUserGroups;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> groupSnapshots =
        await groups(uid);

    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot
        in groupSnapshots) {
      Map<String, dynamic> group = snapshot.data();
      groupData.addAll(group);
    }
    return groupData;
  }
}
