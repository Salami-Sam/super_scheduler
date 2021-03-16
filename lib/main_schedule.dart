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
  static const int daysInWeek = 7;

  @override
  _MainScheduleWidgetState createState() => _MainScheduleWidgetState();
}

class _MainScheduleWidgetState extends State<MainScheduleWidget> {
  // Gets the tab with a particular day's scheduling information
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
    return DefaultTabController(
      length: numDaysInWeek,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Main Schedule: The Krusty Crew'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Su'),
              Tab(text: 'M'),
              Tab(text: 'T'),
              Tab(text: 'W'),
              Tab(text: 'Th'),
              Tab(text: 'F'),
              Tab(text: 'Sa'),
            ],
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
        bottomNavigationBar: DateNavigationRow(),
      ),
    );
  }
}
