import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model.dart';
import 'reusable_schedule_items.dart';
import '../screen_title.dart';

/* Screens:
 * My Availability
 * 
 * Author: Dylan Schulz
 */

class MyAvailabilityWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;

  final String currentGroupId;

  // Need to change to @required and remove default value
  MyAvailabilityWidget({this.currentGroupId = 'RsTjd6INQsNa6RvSTeUX'});

  @override
  _MyAvailabilityWidgetState createState() => _MyAvailabilityWidgetState();
}

class _MyAvailabilityWidgetState extends State<MyAvailabilityWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;
  DocumentReference curWeekScheduleDocRef;
  String currentUsersRole;

  // Gets the role within the given group
  // of the user that is currently logged in to the app
  Future<String> _getCurrentUsersRole() {
    var curUserId = FirebaseAuth.instance.currentUser.uid;
    return currentGroupRef.get().then((value) {
      String role = value['Members'][curUserId];
      // If the user wasn't in the Members map, check the Managers map
      if (role == null) {
        role = value['Managers'][curUserId];
      }
      // If user wasn't in either above map, check the Admins map
      if (role == null) {
        role = value['Admins'][curUserId];
      }
      return role;
    });
  }

  void _changeUsersAvailability(DocumentReference shift, bool isAvailable) {
    shift.get().then((value) {
      List unavailableUsers = value['unavailableUsers'];
      String curUsersId = FirebaseAuth.instance.currentUser.uid;

      if (isAvailable) {
        unavailableUsers.remove(curUsersId);
      } else {
        unavailableUsers.add(curUsersId);
      }

      shift.update({
        'unavailableUsers': unavailableUsers,
      });
    });
  }

  // Gets the tab with a particular day's information
  Widget _getIndividualTab(DateTime today) {
    return Container(
      margin: EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
        stream: curWeekScheduleDocRef.collection('Shifts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('There was an error in retrieving this week\'s schedule.'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            var docsList = snapshot.data.docs;

            // Get only shifts for the current day
            var todaysShifts = docsList.where((element) {
              DateTime shiftDate = element['startDateTime'].toDate();
              if (shiftDate.year == today.year && shiftDate.month == today.month && shiftDate.day == today.day) {
                return true;
              }
              return false;
            }).toList();

            // Sort the shifts in order of start time
            todaysShifts.sort((shift1, shift2) {
              var shift1StartDate = shift1['startDateTime'].toDate();
              var shift2StartDate = shift2['startDateTime'].toDate();
              return shift1StartDate.compareTo(shift2StartDate);
            });

            if (todaysShifts.isEmpty) {
              return Center(child: Text('There are no shifts on this day.'));
            }

            List<QueryDocumentSnapshot> shiftsToDisplay = [];
            for (var shift in todaysShifts) {
              var shiftDocData = shift.data();
              Map rolesNeeded = shiftDocData['rolesNeeded'];
              if (rolesNeeded.containsKey(currentUsersRole)) {
                shiftsToDisplay.add(shift);
              }
            }

            // The actual availability part

            var curUserId = FirebaseAuth.instance.currentUser.uid;

            return ListView.builder(
              itemCount: shiftsToDisplay.length,
              itemBuilder: (context, index) {
                var shiftDocData = shiftsToDisplay[index].data();
                var docRef = todaysShifts[index].reference;
                var startTime = dateTimeToTimeString(shiftDocData['startDateTime'].toDate().toLocal());
                var endTime = dateTimeToTimeString(shiftDocData['endDateTime'].toDate().toLocal());
                List unavailableUsers = shiftDocData['unavailableUsers'];

                // Check whether the user is available for this shift
                var available = true;
                if (unavailableUsers.contains(curUserId)) {
                  available = false;
                }

                return CheckboxListTile(
                  value: available,
                  title: Text('$startTime - $endTime'),
                  onChanged: (val) {
                    _changeUsersAvailability(docRef, val);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  // Return the main contents of this screen
  // after getting the current user's role
  Widget _getScreenContents(DateTime weekStartDate) {
    return FutureBuilder<String>(
      future: _getCurrentUsersRole(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('There was an error in accessing the current user\'s role.'));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          currentUsersRole = snapshot.data;
          return TabBarView(
            children: [
              _getIndividualTab(weekStartDate),
              _getIndividualTab(weekStartDate.add(Duration(days: 1))),
              _getIndividualTab(weekStartDate.add(Duration(days: 2))),
              _getIndividualTab(weekStartDate.add(Duration(days: 3))),
              _getIndividualTab(weekStartDate.add(Duration(days: 4))),
              _getIndividualTab(weekStartDate.add(Duration(days: 5))),
              _getIndividualTab(weekStartDate.add(Duration(days: 6))),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    groups = widget.db.collection('groups');
    currentGroupRef = groups.doc(widget.currentGroupId);

    FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: DateTime.daysPerWeek,
      child: Scaffold(
        appBar: AppBar(
          title: getScreenTitle(
            currentGroupRef: currentGroupRef,
            screenName: 'My Availability',
          ),
          bottom: TabBar(
            tabs: dailyTabList,
          ),
        ),
        body: Consumer<SchedulingStateModel>(
          builder: (context, schedulingStateModel, child) => FutureBuilder<SchedulePublishedPair>(
            future: getWeeklyScheduleDoc(
              groupRef: currentGroupRef,
              weekStartDate: schedulingStateModel.curWeekStartDate,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('There was an error in checking this week\'s schedule.'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                // Check if the schedule existed when checked
                if (snapshot.data == null) {
                  // Did not exist
                  return Center(child: Text('There is no schedule created for this week.'));
                } else {
                  // Did exist, so save it in a variable and return screen contents
                  curWeekScheduleDocRef = snapshot.data.weeklySchedule;
                  return _getScreenContents(schedulingStateModel.curWeekStartDate);
                }
              }
            },
          ),
        ),
        bottomNavigationBar: getDateNavigationRow(),
      ),
    );
  }
}
