import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  DateTime curWeekStartDate;
  DocumentReference curWeekScheduleDocRef;

  // Gets the tab with a particular day's information
  // day goes from 1 (Sunday) to 7 (Saturday)
  Widget getIndividualTab(int day) {
    print(curWeekScheduleDocRef);
    return Container(
      margin: EdgeInsets.all(5),
      child: StreamBuilder<QuerySnapshot>(
        stream: curWeekScheduleDocRef.collection('Shifts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('There was an error in retrieving the schedule.');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Retrieving schedule...');
          } else {
            var docsList = snapshot.data.docs;

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
                      docsList.length,
                      (index) {
                        var docData = docsList[index].data();
                        var startTime =
                            getTimeString2(docData['startDateTime'].toDate());
                        var endTime =
                            getTimeString2(docData['endDateTime'].toDate());
                        return TableRow(
                          children: [
                            getFormattedTextForTable("$startTime"),
                            getFormattedTextForTable("$endTime"),
                            getFormattedTextForTable(
                                "${docData['rolesNeeded']}"),
                          ],
                        );
                      },
                    ),
              ),
            );
          }
        },
      ),
    );
  }

  // Return the main contents of this screen
  Widget getScreenContents() {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TabBarView(
              children: [
                getIndividualTab(1),
                getIndividualTab(2),
                getIndividualTab(3),
                getIndividualTab(4),
                getIndividualTab(5),
                getIndividualTab(6),
                getIndividualTab(7),
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
    curWeekStartDate = getSundayMidnightOfThisWeek();

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
        body: FutureBuilder<DocumentReference>(
          future: getWeeklyScheduleDoc(
            groupRef: currentGroupRef,
            weekStartDate: curWeekStartDate,
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
                    weekStartDate: curWeekStartDate,
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
                      return getScreenContents();
                    }
                  },
                );
              } else {
                // Did exist, so save it in a variable and return screen contents
                curWeekScheduleDocRef = snapshot.data;
                return getScreenContents();
              }
            }
          },
        ),
        bottomNavigationBar: getDateNavigationRow(curWeekStartDate),
      ),
    );
  }
}
