import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../model.dart';
import 'reusable_schedule_items.dart';

/* Screens:
 * Main Schedule
 * 
 * Author: Dylan Schulz
 */

/*
 * Widget for displaying the Main Schedule screen,
 * which displays weekly schedules for all group members.
 */
class MainScheduleWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;

  final String currentGroupId;

  // Need to change to @required and remove default value
  MainScheduleWidget({this.currentGroupId = 'RsTjd6INQsNa6RvSTeUX'});

  @override
  _MainScheduleWidgetState createState() => _MainScheduleWidgetState();
}

class _MainScheduleWidgetState extends State<MainScheduleWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;
  DocumentReference curWeekScheduleDocRef;

  // Gets the tab with a particular day's scheduling information
  Widget _getIndividualTab(DateTime today) {
    return Container(
      margin: EdgeInsets.all(16),
      child: StreamBuilder<QuerySnapshot>(
        stream: curWeekScheduleDocRef.collection('Shifts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('There was an error in retrieving the schedule.'));
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

            // Separate the roles that each shift needs out
            // so that you have list of shift-role-numNeeded tuples
            List<ShiftRoleTuple> shiftRoleTuples = separateIntoShiftRoleTuples(todaysShifts);

            // The actual schedule part

            return ListView.separated(
              itemCount: shiftRoleTuples.length + 1,
              separatorBuilder: tableSeparatorBuilder,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Create the header row
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Start', style: tableHeadingStyle),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('End', style: tableHeadingStyle),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('Role', style: tableHeadingStyle),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('Assignees', style: tableHeadingStyle),
                      ),
                    ],
                  );
                }

                index--; // To account for the header row index

                var shiftRoleTuple = shiftRoleTuples[index];

                var shiftDocData = shiftRoleTuple.shift.data();
                var role = shiftRoleTuple.role;
                var numNeeded = shiftRoleTuple.numNeeded;

                var startTime = dateTimeToTimeString(shiftDocData['startDateTime'].toDate().toLocal());
                var endTime = dateTimeToTimeString(shiftDocData['endDateTime'].toDate().toLocal());
                List allAssignees = shiftDocData['assignees'];

                return Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('$startTime', style: tableBodyStyle),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('$endTime', style: tableBodyStyle),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('$role ($numNeeded)', style: tableBodyStyle),
                      ),
                      Expanded(
                        flex: 3,
                        // Need to get the list of display names of only assignees with this role
                        child: FutureBuilder<Map<String, String>>(
                          future: getUsersWithRole(groupRef: currentGroupRef, neededRole: role),
                          builder: (context, usersSnapshot) {
                            if (usersSnapshot.hasError) {
                              return Text('Error.', style: tableBodyStyle);
                            } else if (usersSnapshot.connectionState == ConnectionState.waiting) {
                              return Text('Retrieving...', style: tableBodyStyle);
                            } else {
                              // Get map of users with the role for the shift
                              Map<String, String> users = usersSnapshot.data;

                              // Remove users from this list who are not assigned to this shift
                              users.removeWhere((key, value) => allAssignees.contains(key) == false);

                              if (users.isEmpty) {
                                return Text('');
                              }
                              return Text(users.values.toList().join(', '), style: tableBodyStyle);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Return the main contents of this screen
  Widget _getScreenContents(DateTime weekStartDate) {
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

  @override
  Widget build(BuildContext context) {
    groups = widget.db.collection('groups');
    currentGroupRef = groups.doc(widget.currentGroupId);

    return DefaultTabController(
      length: DateTime.daysPerWeek,
      child: Scaffold(
        appBar: AppBar(
          title: getScreenTitle(
            currentGroupRef: currentGroupRef,
            screenName: 'Main Schedule',
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
