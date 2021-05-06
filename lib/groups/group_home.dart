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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$groupName (Member)'),
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
                    context, MaterialPageRoute(builder: (context) => ViewMembersWidget(currentGroupId: groupId)));
                //TO DO ?: submit the form
              },
              child: Text('View Members'))
        ])));
  }
}
