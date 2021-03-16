import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * Group Home Page
 */
///@author: James Chartraw
class GroupHomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('The Krusty Crew'),
        ),
        drawer: getUnifiedDrawerWidget(),
        body: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () {
                    //TODO: submit the form
                  },
                  child: Text('My Availability'))),
          ElevatedButton(
              onPressed: () {
                //TODO: submit the form
              },
              child: Text('My Schedules')),
          ElevatedButton(
              onPressed: () {
                //TODO: submit the form
              },
              child: Text('Main Schedule')),
          ElevatedButton(
              onPressed: () {
                //TODO: submit the form
              },
              child: Text('View Members'))
        ]));
  }
}
