import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  DateTime curWeekStartDate;

  // Gets the tab with a particular day's scheduling information
  Widget getIndividualTab(int day) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ListView.separated(
        itemCount: 15,
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
                  flex: 2,
                  child: Text('Role', style: tableHeadingStyle),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Name', style: tableHeadingStyle),
                ),
              ],
            );
          }
          index--; // To account for the header row index
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('${getRandomTime()}', style: tableBodyStyle),
              ),
              Expanded(
                flex: 2,
                child: Text('${getRandomTime()}', style: tableBodyStyle),
              ),
              Expanded(
                flex: 2,
                child: Text('${getRandomRole()}', style: tableBodyStyle),
              ),
              Expanded(
                flex: 3,
                child: Text('${getRandomName()}', style: tableBodyStyle),
              ),
            ],
          );
        },
      ),
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
