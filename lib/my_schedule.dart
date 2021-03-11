import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * My Schedule
 */

class MyScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Schedule: The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}
