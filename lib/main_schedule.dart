import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  // Temporarily set to constant value
  // Eventually should be passed in from the Group Home Page
  final String currentGroupId = 'RsTjd6INQsNa6RvSTeUX';

  //MainScheduleWidget({@required this.currentGroupId});

  @override
  _MainScheduleWidgetState createState() => _MainScheduleWidgetState();
}

class _MainScheduleWidgetState extends State<MainScheduleWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;
  DateTime curWeekStartDate;

  // Gets the tab with a particular day's scheduling information
  Widget getIndividualTab(int day) {
    return Container(
      margin: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                getFormattedTextForTable('Start'),
                getFormattedTextForTable('End'),
                getFormattedTextForTable('Role'),
                getFormattedTextForTable('Name'),
              ],
            ),
            TableRow(
              children: [
                getFormattedTextForTable('${getRandomTime()}'),
                getFormattedTextForTable('${getRandomTime()}'),
                getFormattedTextForTable('${getRandomRole()}'),
                getFormattedTextForTable('${getRandomName()}'),
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
    curWeekStartDate;

    return DefaultTabController(
      length: numDaysInWeek,
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
        body: TabBarView(
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
        bottomNavigationBar: getDateNavigationRow(),
      ),
    );
  }
}
