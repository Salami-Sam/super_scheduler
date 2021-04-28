import 'package:flutter/material.dart';

import 'scheduling/main_schedule.dart';
import 'member_management/member_management.dart';
import 'scheduling/my_availability.dart';
import 'scheduling/my_schedule.dart';
import 'scheduling/primary_scheduler.dart';

/*
 * Group Home Manager Page
 */
///@author: James Chartraw
class GroupHomeManagerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group Home (Manager)'),
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
                  child: Text('Edit Members'))
            ])));
  }
}
