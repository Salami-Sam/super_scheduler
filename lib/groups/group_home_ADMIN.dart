import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/member_management/edit_roles.dart';
import 'package:super_scheduler/member_management/member_management_ADMIN.dart';

import '../screen_title.dart';
import 'group_management.dart';
import 'package:super_scheduler/scheduling/main_schedule.dart';
import 'package:super_scheduler/scheduling/my_availability.dart';
import 'package:super_scheduler/scheduling/my_schedule.dart';
import 'package:super_scheduler/scheduling/primary_scheduler.dart';

/*
 * Group Home Admin Page
 */
///@author: James Chartraw
///

class GroupHomeAdminWidget extends StatefulWidget {
  final String groupId;
  GroupHomeAdminWidget(this.groupId);

  @override
  _GroupHomeAdminWidgetState createState() => _GroupHomeAdminWidgetState();
}

class _GroupHomeAdminWidgetState extends State<GroupHomeAdminWidget> {
  Widget getDescriptionWidget() {
    return Container(
      margin: EdgeInsets.all(8),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('groups')
            .doc('${widget.groupId}')
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
                  .doc('${widget.groupId}'),
              screenName: 'Admin'),
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
                                      builder: (context) =>
                                          MyAvailabilityWidget(
                                              currentGroupId: widget.groupId)));
                            },
                            child: Text('My Availability'))),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyScheduleWidget(
                                      currentGroupId: widget.groupId)));
                        },
                        child: Text('My Schedules')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScheduleWidget(
                                      currentGroupId: widget.groupId)));
                        },
                        child: Text('Main Schedule')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrimarySchedulerWidget(
                                      currentGroupId: widget.groupId)));
                        },
                        child: Text('Scheduler')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditMemberAdminWidget(
                                      currentGroupId: widget.groupId)));
                        },
                        child: Text('Edit Members')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditRolesWidget(
                                      currentGroupId: widget.groupId)));
                        },
                        child: Text('Edit Group Roles')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditGroupWidget(
                                          currentGroupId: widget.groupId)))
                              .then((value) {
                            // This future then method is called when the EditGroupWidget pops
                            // If EditGroupWidget was popped by clicking the Save Changes button,
                            // value will be the name of the group
                            // If it popped using the back button, value will be null
                            // So, if changes were made, rebuild this screen to update the app bar title
                            // that is the name of the group
                            if (value != null) {
                              print(value);
                              setState(() {});
                            }
                          });
                        },
                        child: Text('Edit Group'))
                  ]),
            )));
  }
}
