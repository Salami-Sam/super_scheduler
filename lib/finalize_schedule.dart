import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main_schedule.dart';
import 'reusable_schedule_items.dart';

/* Screens:
 * Finalize Schedule
 * 
 * Author: Dylan Schulz
 */

class FinalizeScheduleWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;
  final String currentGroupId;

  FinalizeScheduleWidget({@required this.currentGroupId});

  @override
  _FinalizeScheduleWidgetState createState() => _FinalizeScheduleWidgetState();
}

class _FinalizeScheduleWidgetState extends State<FinalizeScheduleWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;

  // Placeholder list of names
  List<String> names = [
    'Spongebob Squarepants',
    'Squidward Tentacles',
    'Patrick Star',
    'Eugene Krabs'
  ];

  // Gets text nicely formatted for use in a table
  Widget getFormattedTextForTable(String contents) {
    return Padding(
        child: Text(
          contents,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        padding: EdgeInsets.all(5));
  }

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
    groups = widget.db.collection('groups');
    currentGroupRef = groups.doc(widget.currentGroupId);

    return DefaultTabController(
      length: DateTime.daysPerWeek,
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
                        // How close tiles are to each other
                        vertical: -3,
                      ),
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
