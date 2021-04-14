import 'package:flutter/material.dart';
import 'main_schedule.dart';
import 'view_members.dart';
import 'my_availability.dart';
import 'my_schedule.dart';

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
                            builder: (context) => ViewMembersWidget()));
                    //TODO: submit the form
                  },
                  child: Text('View Members'))
            ])));
  }
}
