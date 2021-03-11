import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * Primary Scheduler
 * Add Shift
 * Finalize Schedule
 */

class PrimarySchedulerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduler: The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Primary scheduler placeholder'),
    );
  }
}

class AddShiftWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Shift: The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}

class FinalizeScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduler: The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Finalize schedule placeholder'),
    );
  }
}
