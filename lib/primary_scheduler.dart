import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_scheduler/model.dart';
import 'reusable_schedule_items.dart';
import 'finalize_schedule.dart';
import 'add_shift.dart';

/* Screens:
 * Primary Scheduler
 *
 * Author: Dylan Schulz
 */

class PrimarySchedulerWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;

  // Temporarily set to constant value
  // Eventually should be passed in from the Group Home Page
  final String currentGroupId = 'RsTjd6INQsNa6RvSTeUX';

  //PrimarySchedulerWidget({@required this.currentGroupId});

  @override
  _PrimarySchedulerWidgetState createState() => _PrimarySchedulerWidgetState();
}

class _PrimarySchedulerWidgetState extends State<PrimarySchedulerWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;
  DocumentReference curWeekScheduleDocRef;

  // Gets the tab with a particular day's information
  Widget getIndividualTab(DateTime today) {
    return Container(
      margin: EdgeInsets.all(5),
      child: StreamBuilder<QuerySnapshot>(
        stream: curWeekScheduleDocRef.collection('Shifts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('There was an error in retrieving the schedule.'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Retrieving schedule...'));
          } else {
            var docsList = snapshot.data.docs;
            var todaysShifts = docsList.where((element) {
              DateTime shiftDate = element['startDateTime'].toDate();
              if (shiftDate.year == today.year &&
                  shiftDate.month == today.month &&
                  shiftDate.day == today.day) {
                return true;
              }
              return false;
            }).toList();
            if (todaysShifts.isEmpty) {
              return Center(child: Text('There are no shifts on this day.'));
            } else {
              return SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
                  children: [
                        TableRow(children: [
                          getFormattedTextForTable('Start'),
                          getFormattedTextForTable('End'),
                          getFormattedTextForTable('Roles'),
                        ])
                      ] +
                      List<TableRow>.generate(
                        todaysShifts.length,
                        (index) {
                          var docData = todaysShifts[index].data();
                          var startTime = dateTimeToTimeString(
                              docData['startDateTime'].toDate());
                          var endTime = dateTimeToTimeString(
                              docData['endDateTime'].toDate());
                          var roleList =
                              getRoleMapString(docData['rolesNeeded']);

                          return TableRow(
                            children: [
                              getFormattedTextForTable("$startTime"),
                              getFormattedTextForTable("$endTime"),
                              getFormattedTextForTable("$roleList"),
                            ],
                          );
                        },
                      ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  // Return the main contents of this screen
  Widget getScreenContents(DateTime weekStartDate) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TabBarView(
              children: [
                getIndividualTab(weekStartDate),
                getIndividualTab(weekStartDate.add(Duration(days: 1))),
                getIndividualTab(weekStartDate.add(Duration(days: 2))),
                getIndividualTab(weekStartDate.add(Duration(days: 3))),
                getIndividualTab(weekStartDate.add(Duration(days: 4))),
                getIndividualTab(weekStartDate.add(Duration(days: 5))),
                getIndividualTab(weekStartDate.add(Duration(days: 6))),
              ],
            ),
          ),
          ElevatedButton(
            child: Text('Add Shift'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddShiftWidget(
                    currentGroupId: widget.currentGroupId,
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            child: Text('Remove Selected Shift'),
            onPressed: null,
          ),
          ElevatedButton(
            child: Text('Finalize Schedule'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FinalizeScheduleWidget(
                    currentGroupId: widget.currentGroupId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    groups = widget.db.collection('groups');
    currentGroupRef = groups.doc(widget.currentGroupId);

    return DefaultTabController(
      length: numDaysInWeek,
      child: Scaffold(
        appBar: AppBar(
          title: getScreenTitle(
            currentGroupRef: currentGroupRef,
            screenName: 'Scheduler',
          ),
          bottom: TabBar(
            tabs: dailyTabList,
          ),
        ),
        body: Consumer<AppStateModel>(
          builder: (context, appStateModel, child) =>
              FutureBuilder<DocumentReference>(
            future: getWeeklyScheduleDoc(
              groupRef: currentGroupRef,
              weekStartDate: appStateModel.curWeekStartDate,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'There was an error in checking this week\'s schedule.'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Preparing schedule...'));
              } else {
                // Check if the schedule existed when checked
                if (snapshot.data == null) {
                  // Did not exist, so create it in a Future
                  return FutureBuilder<DocumentReference>(
                    future: createWeeklyScheduleDoc(
                      groupRef: currentGroupRef,
                      weekStartDate: appStateModel.curWeekStartDate,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'There was an error in creating this week\'s schedule.'));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: Text('Preparing schedule...'));
                      } else {
                        // Save the schedule ref in a var and return screen contents
                        curWeekScheduleDocRef = snapshot.data;
                        return getScreenContents(
                            appStateModel.curWeekStartDate);
                      }
                    },
                  );
                } else {
                  // Did exist, so save it in a variable and return screen contents
                  curWeekScheduleDocRef = snapshot.data;
                  return getScreenContents(appStateModel.curWeekStartDate);
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
