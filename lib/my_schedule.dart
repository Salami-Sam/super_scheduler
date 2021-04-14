import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reusable_schedule_items.dart';

/* Screens:
 * My Schedule
 * 
 * Author: Dylan Schulz
 */

/*
 * Widget for displaying the My Schedule screen,
 * which displays weekly schedules for a particular group
 * for the logged in user.
 */
class MyScheduleWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;

  // Temporarily set to constant value
  // Eventually should be passed in from the Group Home Page
  final String currentGroupId = 'RsTjd6INQsNa6RvSTeUX';

  //MyScheduleWidget({@required this.currentGroupId});

  final List<String> days = [
    'Sunday:',
    'Monday:',
    'Tuesday:',
    'Wednesday:',
    'Thursday:',
    'Friday:',
    'Saturday:'
  ];

  @override
  _MyScheduleWidgetState createState() => _MyScheduleWidgetState();
}

class _MyScheduleWidgetState extends State<MyScheduleWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;

  // Placeholder times for now
  // Will eventually call methods to get actual times
  final List<String> dailyTimes = [
    'OFF',
    '10:00 AM - 6:00 PM',
    '11:00 AM - 7:00 PM',
    'OFF',
    '8:00 AM - 5:00 PM',
    '8:00 AM - 6:00 PM',
    '7:00 AM - 4:00 PM'
  ];

  @override
  Widget build(BuildContext context) {
    groups = widget.db.collection('groups');
    currentGroupRef = groups.doc(widget.currentGroupId);

    return Scaffold(
      appBar: AppBar(
        title: getScreenTitle(
          currentGroupRef: currentGroupRef,
          screenName: 'My Schedule',
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Spongebob\'s Schedule',
              style: TextStyle(fontSize: 26),
            ),
            Divider(
              color: Colors.black,
              thickness: 2.0,
              height: 30.0,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: numDaysInWeek,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      widget.days[index],
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      dailyTimes[index],
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
                separatorBuilder: (context, int) {
                  return Divider(
                    color: Colors.black,
                    thickness: 1.0,
                    height: 1.0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DateNavigationRow(),
    );
  }
}
