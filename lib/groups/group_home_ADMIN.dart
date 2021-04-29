import 'package:flutter/material.dart';

import 'group_management.dart';
import 'package:super_scheduler/scheduling/main_schedule.dart';
import 'package:super_scheduler/member_management/member_management.dart';
import 'package:super_scheduler/scheduling/my_availability.dart';
import 'package:super_scheduler/scheduling/my_schedule.dart';
import 'package:super_scheduler/scheduling/primary_scheduler.dart';

/*
 * Group Home Admin Page
 */
///@author: James Chartraw
class GroupHomeAdminWidget extends StatelessWidget {
  final String groupId;
  GroupHomeAdminWidget(this.groupId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group Home (Admin)'),
        ),
        body: Center(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Container(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyAvailabilityWidget(currentGroupId: groupId)));
                  },
                  child: Text('My Availability'))),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyScheduleWidget(currentGroupId: groupId)));
              },
              child: Text('My Schedules')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MainScheduleWidget(currentGroupId: groupId)));
              },
              child: Text('Main Schedule')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PrimarySchedulerWidget(currentGroupId: groupId)));
              },
              child: Text('Scheduler')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditMemberWidget(currentGroupId: groupId)));
              },
              child: Text('Edit Members')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditGroupWidget()));
              },
              child: Text('Edit Group'))
        ])));
  }
}
