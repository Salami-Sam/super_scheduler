import 'package:flutter/material.dart';

/* Screens:
 * Primary Scheduler
 * Add Shift
 * Finalize Schedule
 * 
 * Author: Dylan Schulz
 */

class PrimarySchedulerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduler: The Krusty Crew'),
      ),
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
      body: Text('Finalize schedule placeholder'),
    );
  }
}
