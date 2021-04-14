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

  // Gets the tab with a particular day's information
  Widget getIndividualTab(int day) {
    return Container(
      margin: EdgeInsets.all(5),
      child: StreamBuilder<DocumentSnapshot>(
        stream: currentGroupRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('There was an error in retrieving the schedule.');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Retrieving schedule...');
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
                      3,
                      (index) {
                        return TableRow(
                          children: [
                            getFormattedTextForTable('${getRandomTime()}'),
                            getFormattedTextForTable('${getRandomTime()}'),
                            getFormattedTextForTable('${getRandomRole()}'),
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

  @override
  Widget build(BuildContext context) {
    groups = widget.db.collection('groups');
    currentGroupRef = groups.doc(widget.currentGroupId);
    curWeekStartDate = getSundayMidnightOfThisWeek();

    createWeeklyScheduleDoc(
      groupRef: currentGroupRef,
      weekStartDate: curWeekStartDate,
    );

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
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    getIndividualTab(0),
                    getIndividualTab(1),
                    getIndividualTab(2),
                    getIndividualTab(3),
                    getIndividualTab(4),
                    getIndividualTab(5),
                    getIndividualTab(6),
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
        ),
        bottomNavigationBar: getDateNavigationRow(curWeekStartDate),
      ),
    );
  }
}
