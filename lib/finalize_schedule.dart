import 'package:flutter/material.dart';
import 'main_schedule.dart';
import 'reusable_schedule_items.dart';

/* Screens:
 * Finalize Schedule
 * 
 * Author: Dylan Schulz
 */

class FinalizeScheduleWidget extends StatefulWidget {
  @override
  _FinalizeScheduleWidgetState createState() => _FinalizeScheduleWidgetState();
}

class _FinalizeScheduleWidgetState extends State<FinalizeScheduleWidget> {
  // Placeholder list of names
  List<String> names = [
    'Spongebob Squarepants',
    'Squidward Tentacles',
    'Patrick Star',
    'Eugene Krabs'
  ];

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
                getFormattedTextForTable('Role'),
                getFormattedTextForTable('Name'),
              ],
            ),
            TableRow(
              children: [
                getFormattedTextForTable('${getRandomTime()}'),
                getFormattedTextForTable('${getRandomTime()}'),
                getFormattedTextForTable('${getRandomRole()}'),
                getFormattedTextForTable(
                    'Tap here, then tap a name from the list'),
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
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
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
            Expanded(
              child: ListView.separated(
                itemCount: names.length, //Placeholder
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(names[index]),
                  );
                },
                separatorBuilder: (context, int) {
                  return Divider(
                    color: Colors.white,
                    thickness: 0,
                    height: 0.1,
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text('Publish Schedule'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScheduleWidget(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
