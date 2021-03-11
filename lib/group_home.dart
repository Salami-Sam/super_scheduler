import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * Group Home Page
 */

class GroupHomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Individual group home page placeholder'),
    );
  }
}
