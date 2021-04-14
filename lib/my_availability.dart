import 'package:flutter/material.dart';
import 'reusable_schedule_items.dart';

/* Screens:
 * My Availability
 * 
 * Author: Dylan Schulz
 */

class MyAvailabilityWidget extends StatefulWidget {
  @override
  _MyAvailabilityWidgetState createState() => _MyAvailabilityWidgetState();
}

class _MyAvailabilityWidgetState extends State<MyAvailabilityWidget> {
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
    return DefaultTabController(
      length: numDaysInWeek,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Availability: The Krusty Crew'),
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
