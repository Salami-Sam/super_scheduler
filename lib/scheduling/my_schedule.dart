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
            return Center(child: CircularProgressIndicator());
          } else {
            var shiftDocsList = snapshot.data.docs;
            var thisUsersId = FirebaseAuth.instance.currentUser.uid;

            // Get a list of shifts where the current user is in the list of assignees
            List<QueryDocumentSnapshot> thisUsersShifts =
                shiftDocsList.where((element) => element['assignees'].contains(thisUsersId)).toList();

            // Sort the shifts in order of start date and time
            thisUsersShifts.sort((shift1, shift2) {
              var shift1StartDate = shift1['startDateTime'].toDate();
              var shift2StartDate = shift2['startDateTime'].toDate();
              return shift1StartDate.compareTo(shift2StartDate);
            });

            if (thisUsersShifts.length == 0) {
              return Center(child: Text('You have no shifts this week!'));
            }

            // Separate shifts out by day and get the desired output format

            List<String> listViewTitles = [];
            int lastInputWeekday = -1; // Keeps track of when headers were stored into listViewTitles
            List<String> shiftStrings = [];

            for (var shift in thisUsersShifts) {
              var shiftDocData = shift.data();

              DateTime startDateTime = shiftDocData['startDateTime'].toDate().toLocal();
              var weekday = weekdayIntConversion(startDateTime.weekday);
              var startTime = dateTimeToTimeString(startDateTime);
              var endTime = dateTimeToTimeString(shiftDocData['endDateTime'].toDate().toLocal());

              // If we skipped a day of the week, add a line for it
              // If the compared ints are larger than 1 apart, then we skipped at least one day
              // Keep adding necessary lines until we are only one day apart
              while ((weekday - lastInputWeekday).abs() > 1) {
                lastInputWeekday++;
                listViewTitles.add('${weekdayIntToString(lastInputWeekday)}:');
                shiftStrings.add('OFF');
              }

              // Add a new header if this is the first shift for this day
              if (lastInputWeekday < weekday) {
                listViewTitles.add('${weekdayIntToString(weekday)}:');
                lastInputWeekday++;
              } else {
                // Add a blank space instead of a header
                listViewTitles.add('');
              }
              shiftStrings.add('$startTime - $endTime');
            }

            // If there are weekdays left without shifts, add lines for them
            while (lastInputWeekday < 6) {
              lastInputWeekday++;
              listViewTitles.add('${weekdayIntToString(lastInputWeekday)}:');
              shiftStrings.add('OFF');
            }

            return ListView.separated(
              itemCount: shiftStrings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${listViewTitles[index]}',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    '${shiftStrings[index]}',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                // Return a different divider between days than
                // between shifts on the same day
                // If this divider will come after the final shift of a day,
                // then that shift will either have no title or have OFF as the shift time
                if (listViewTitles.elementAt(index) == '' || shiftStrings.elementAt(index) == 'OFF') {
                  // Between days
                  return Divider(
                    color: Colors.black,
                    thickness: 1.0,
                    height: 1.0,
                  );
                } else {
                  // Between same day shifts
                  return Divider(
                    // Blend in with the background
                    color: Theme.of(context).scaffoldBackgroundColor,
                    thickness: 1.0,
                    height: 1.0,
                  );
                }
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
                      return Center(child: CircularProgressIndicator());
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
