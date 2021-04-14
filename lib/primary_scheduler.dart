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

  // Gets the tab with a particular day's information
  Widget getIndividualTab(int day) {
    return Container(
      margin: EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                getFormattedTextForTable('Start'),
                getFormattedTextForTable('End'),
                getFormattedTextForTable('Roles'),
              ],
            ),
            TableRow(
              children: [
                getFormattedTextForTable('${getRandomTime()}'),
                getFormattedTextForTable('${getRandomTime()}'),
                getFormattedTextForTable('${getRandomRoleset()}'),
              ],
            ),
            TableRow(
              children: [
                getFormattedTextForTable('${getRandomTime()}'),
                getFormattedTextForTable('${getRandomTime()}'),
                getFormattedTextForTable('${getRandomRoleset()}'),
              ],
            ),
          ],
        ),
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
        body: Container(
          margin: EdgeInsets.only(
            top: 8,
            left: 8,
            right: 8,
          ),
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
        bottomNavigationBar: DateNavigationRow(),
      ),
    );
  }
}
