import 'package:flutter/material.dart';

import 'group_management.dart';
import 'main_schedule.dart';
import 'member_management.dart';
import 'my_availability.dart';
import 'my_schedule.dart';
import 'primary_scheduler.dart';

/*
 * Group Home Admin Page
 */
///@author: James Chartraw
class GroupHomeAdminWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group Home (Admin)'),
        ),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            builder: (context) => PrimarySchedulerWidget()));
                  },
                  child: Text('Scheduler')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditMemberWidget()));
                  },
                  child: Text('Edit Members')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditGroupWidget()));
                  },
                  child: Text('Edit Group'))
            ])));
  }
}