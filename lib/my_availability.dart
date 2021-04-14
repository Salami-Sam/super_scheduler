import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reusable_schedule_items.dart';

/* Screens:
 * My Availability
 * 
 * Author: Dylan Schulz
 */

class MyAvailabilityWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;

  // Temporarily set to constant value
  // Eventually should be passed in from the Group Home Page
  final String currentGroupId = 'RsTjd6INQsNa6RvSTeUX';

  //MyAvailabilityWidget({@required this.currentGroupId});

  @override
  _MyAvailabilityWidgetState createState() => _MyAvailabilityWidgetState();
}

class _MyAvailabilityWidgetState extends State<MyAvailabilityWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;

  // Gets the tab with a particular day's information
  Widget getIndividualTab(int day) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: 2, //Placeholder
        itemBuilder: (context, index) {
          return CheckboxListTile(
            value: false,
            title: Text('${getRandomTime()} - ${getRandomTime()}'),
            onChanged: null,
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
      length: numDaysInWeek,
      child: Scaffold(
        appBar: AppBar(
          title: getScreenTitle(
            currentGroupRef: currentGroupRef,
            screenName: 'My Availability',
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
        bottomNavigationBar: DateNavigationRow(),
      ),
    );
  }
}
