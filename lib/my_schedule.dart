import 'package:flutter/material.dart';

/* Screens:
 * My Schedule
 * 
 * Author: Dylan Schulz
 */

class MyScheduleWidget extends StatefulWidget {
  @override
  _MyScheduleWidgetState createState() => _MyScheduleWidgetState();
}

class _MyScheduleWidgetState extends State<MyScheduleWidget> {
  // Placeholder times for now
  // Will eventually call methods to get actual times
  final List<String> days = [
    'Sunday: OFF',
    'Monday: 10:00 AM - 6:00 PM',
    'Tuesday: 11:00 AM - 7:00 PM',
    'Wednesday: OFF',
    'Thursday: 8:00 AM - 5:00 PM',
    'Friday: 8:00 AM - 6:00 PM',
    'Saturday: 7:00 AM - 4:00 PM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Schedule: The Krusty Crew'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Spongebob\'s Schedule',
              style: TextStyle(fontSize: 26),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: null,
                ),
                Text(
                  'For the week 3/14/21 to 3/20/21',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: null,
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: days.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(days[index]),
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
    );
  }
}
