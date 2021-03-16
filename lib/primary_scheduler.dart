import 'package:flutter/material.dart';
import 'reusable_schedule_items.dart';
import 'finalize_schedule.dart';

/* Screens:
 * Primary Scheduler
 * Add Shift
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
              height: 4 * MediaQuery.of(context).size.height / 7,
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
            DateNavigationRow(),
          ],
        ),
      ),
    );
  }
}

class AddShiftWidget extends StatelessWidget {
  List<String> roles = ['GM', 'Busboy', 'Cashier', 'Fry Cook'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Shift: The Krusty Crew'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Start Time',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Hour'),
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Minute'),
                ),
              ),
              DropdownButton(
                items: [
                  DropdownMenuItem(child: Text('AM')),
                  DropdownMenuItem(child: Text('PM'))
                ],
                onChanged: (selection) {},
              ),
            ],
          ),
          Text(
            'End Time',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Hour'),
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Minute'),
                ),
              ),
              DropdownButton(
                items: [
                  DropdownMenuItem(child: Text('AM')),
                  DropdownMenuItem(child: Text('PM'))
                ],
                onChanged: (selection) {},
              ),
            ],
          ),
          Text(
            'Roles Needed',
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: null,
                  ),
                  title: Text(roles[index]),
                  subtitle: Text('1'),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: null,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            child: Text('Add Shift'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
