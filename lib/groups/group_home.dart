import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/scheduling/main_schedule.dart';
import 'package:super_scheduler/member_management/view_members.dart';
import 'package:super_scheduler/scheduling/my_availability.dart';
import 'package:super_scheduler/scheduling/my_schedule.dart';

/* Screens:
 * Group Home Page
 */
///@author: James Chartraw
class GroupHomeWidget extends StatelessWidget {
  final String groupId, groupName;
  GroupHomeWidget(this.groupId, this.groupName);

  // Gets the description for the given group
  // Author: Dylan Schulz
  Future<String> getDescription(String currentGroupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc('$currentGroupId')
        .get()
        .then((docref) {
      if (docref.exists) {
        return docref['description'];
      } else {
        return 'There was an error in retrieving the description.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$groupName (Member)'),
        ),
        body: Container(
            margin: EdgeInsets.all(8),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(8),
                      child: Text(
                        'Group Description:',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      )),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: FutureBuilder(
                      future: getDescription(groupId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'There was an error in retrieving the description.',
                              style: TextStyle(fontSize: 16.0));
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          return Text('${snapshot.data}',
                              style: TextStyle(fontSize: 16.0));
                        }
                      },
                    ),
                  ),
                  Container(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAvailabilityWidget(
                                        currentGroupId: groupId)));
                          },
                          child: Text('My Availability'))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyScheduleWidget(currentGroupId: groupId)));
                      },
                      child: Text('My Schedules')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScheduleWidget(
                                    currentGroupId: groupId)));
                      },
                      child: Text('Main Schedule')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewMembersWidget(
                                    currentGroupId: groupId)));
                        //TO DO ?: submit the form
                      },
                      child: Text('View Members'))
                ]))));
  }
}
