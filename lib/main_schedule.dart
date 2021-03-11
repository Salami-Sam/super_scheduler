import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * Main Schedule
 */

class MainScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Schedule: The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}
