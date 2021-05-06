import 'package:flutter/material.dart';

import 'package:super_scheduler/scheduling/main_schedule.dart';
import 'package:super_scheduler/member_management/member_management.dart';
import 'package:super_scheduler/scheduling/my_availability.dart';
import 'package:super_scheduler/scheduling/my_schedule.dart';
import 'package:super_scheduler/scheduling/primary_scheduler.dart';

/*
 * Group Home Manager Page
 */
///@author: James Chartraw
class GroupHomeManagerWidget extends StatelessWidget {
  final String groupId, groupName;
  GroupHomeManagerWidget(this.groupId, this.groupName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$groupName (Manager)'),
        ),
        body: Container(
            margin: EdgeInsets.all(8),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PrimarySchedulerWidget(currentGroupId: groupId)));
                  },
                  child: Text('Scheduler')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => EditMemberWidget(currentGroupId: groupId)));
                  },
                  child: Text('Edit Members'))
            ])));
  }
}
