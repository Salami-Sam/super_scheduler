import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model.dart';
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

  final String currentGroupId;

  // Need to change to @required and remove default value
  MyScheduleWidget({this.currentGroupId = 'RsTjd6INQsNa6RvSTeUX'});

  @override
  _MyScheduleWidgetState createState() => _MyScheduleWidgetState();
}

class _MyScheduleWidgetState extends State<MyScheduleWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;
  DocumentReference curWeekScheduleDocRef;

  // Gets the actual schedule portion of the screen
  Widget _getScreenContents(DateTime weekStartDate) {
    return StreamBuilder<QuerySnapshot>(
        stream: curWeekScheduleDocRef.collection('Shifts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('There was an error in retrieving the schedule.'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Retrieving schedule...'));
          } else {
            var shiftDocsList = snapshot.data.docs;
            var thisUsersId = FirebaseAuth.instance.currentUser.uid;

            // Get a list of shifts where the current user is in the list of assignees
            List thisUsersShifts =
                shiftDocsList.where((element) => element['assignees'].contains(thisUsersId)).toList();

            // Sort the shifts in order of start time
            thisUsersShifts.sort((shift1, shift2) {
              var shift1StartDate = shift1['startDateTime'].toDate();
              var shift2StartDate = shift2['startDateTime'].toDate();
              return shift1StartDate.compareTo(shift2StartDate);
            });

            Map<String, String> dailyShifts = {
              'Sunday:': 'OFF',
              'Monday:': 'OFF',
              'Tuesday:': 'OFF',
              'Wednesday:': 'OFF',
              'Thursday:': 'OFF',
              'Friday:': 'OFF',
              'Saturday:': 'OFF',
            };

            return ListView.separated(
              itemCount: dailyShifts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    dailyShifts.keys.elementAt(index),
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    dailyShifts.values.elementAt(index),
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
            );
          }
        });
  }

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
              '${FirebaseAuth.instance.currentUser.displayName}\'s Schedule',
              style: TextStyle(fontSize: 26),
            ),
            Divider(
              color: Colors.black,
              thickness: 2.0,
              height: 30.0,
            ),
            Expanded(
              child: Consumer<AppStateModel>(
                builder: (context, appStateModel, child) => FutureBuilder<SchedulePublishedPair>(
                  future: getWeeklyScheduleDoc(
                    groupRef: currentGroupRef,
                    weekStartDate: appStateModel.curWeekStartDate,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('There was an error in checking this week\'s schedule.'));
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('Retrieving schedule...'));
                    } else {
                      // Check the schedule for this week
                      if (snapshot.data == null) {
                        // Did not exist when checked
                        return Center(child: Text('There is no schedule created for this week.'));
                      } else if (snapshot.data.isPublished == false) {
                        // The schedule for this week is not published
                        return Center(child: Text('The schedule for this week is not published.'));
                      } else {
                        // Did exist and is published, so save it in a variable and return screen contents
                        curWeekScheduleDocRef = snapshot.data.weeklySchedule;
                        return _getScreenContents(appStateModel.curWeekStartDate);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: getDateNavigationRow(),
    );
  }
}
