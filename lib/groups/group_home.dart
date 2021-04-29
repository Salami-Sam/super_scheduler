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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group Home (Member)'),
        ),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Container(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyAvailabilityWidget()));
                      },
                      child: Text('My Availability'))),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyScheduleWidget()));
                  },
                  child: Text('My Schedules')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainScheduleWidget()));
                  },
                  child: Text('Main Schedule')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewMembersWidget()));
                  },
                  child: Text('View Members'))
            ])));
  }
}
