import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/scheduling/main_schedule.dart';
import 'package:super_scheduler/member_management/view_members.dart';
import 'package:super_scheduler/scheduling/my_availability.dart';
import 'package:super_scheduler/scheduling/my_schedule.dart';

import '../screen_title.dart';

/* Screens:
 * Group Home Page
 */
///@author: James Chartraw
class GroupHomeWidget extends StatelessWidget {
  final String groupId;
  GroupHomeWidget(this.groupId);

  // A StreamBuilder for the description of the current group
  Widget getDescriptionWidget() {
    return Container(
      margin: EdgeInsets.all(8),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('groups')
            .doc('$groupId')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('There was an error in retrieving the description.',
                style: TextStyle(fontSize: 16.0));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: CircularProgressIndicator(),
              alignment: Alignment.centerLeft,
            );
          } else {
            var description = snapshot.data['description'];
            return Text('$description', style: TextStyle(fontSize: 16.0));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: getScreenTitleWithParen(
              currentGroupRef: FirebaseFirestore.instance
                  .collection('groups')
                  .doc('$groupId'),
              screenName: 'Member'),
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
                  getDescriptionWidget(),
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
                      child: Text('My Schedule')),
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
