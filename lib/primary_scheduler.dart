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
  @override
  _PrimarySchedulerWidgetState createState() => _PrimarySchedulerWidgetState();
}

class _PrimarySchedulerWidgetState extends State<PrimarySchedulerWidget> {
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
    return DefaultTabController(
      length: numDaysInWeek,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scheduler: The Krusty Crew'),
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
                      builder: (context) => AddShiftWidget(),
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
                      builder: (context) => FinalizeScheduleWidget(),
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
