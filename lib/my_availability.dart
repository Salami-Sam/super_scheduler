import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * My Availability
 */

class MyAvailabilityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Availability: The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}
