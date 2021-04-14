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
            tabs: dailyTabList,
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // First 2 widgets have remaining divided between them
              Expanded(
                flex: 2, // 2/3 of the available space
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
                flex: 1, // 1/3 of the available space
                child: ListView.builder(
                  itemCount: names.length, //Placeholder
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(names[index]),
                      visualDensity: VisualDensity(
                        vertical: -3,
                      ), // How close tiles are to each other
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
      ),
    );
  }
}
