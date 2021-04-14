import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reusable_schedule_items.dart';

/* Screens:
 * Add Shift
 *
 * Author: Dylan Schulz
 */

// A widget for adding shifts to the schedule
// Still needs some work
class AddShiftWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;
  final String currentGroupId;

  AddShiftWidget({@required this.currentGroupId});

  static const List<String> roles = ['GM', 'Busboy', 'Cashier', 'Fry Cook'];

  @override
  _AddShiftWidgetState createState() => _AddShiftWidgetState();
}

class _AddShiftWidgetState extends State<AddShiftWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;

  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 17, minute: 0);

  // Uses showTimePicker to let the user pick a time,
  // and assigns it to the appropriate variable
  // if isStartTime is true, sets the startTime
  // if isStartTime is false, sets the end time
  void _chooseTime(TimeOfDay initialTime, bool isStartTime) {
    Future<TimeOfDay> chosenTimeFuture = showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    chosenTimeFuture.then((value) {
      if (value != null) {
        setState(() {
          if (isStartTime) {
            startTime = value;
          } else {
            endTime = value;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    groups = widget.db.collection('groups');
    currentGroupRef = groups.doc(widget.currentGroupId);

    return Scaffold(
      appBar: AppBar(
        title: getScreenTitle(
          currentGroupRef: currentGroupRef,
          screenName: 'Add Shift',
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 16,
          bottom: 8,
          left: 8,
          right: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Choose Start Time:'),
                  onPressed: () {
                    _chooseTime(startTime, true);
                  },
                ),
                Text(
                  '${getTimeString(startTime)}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Choose End Time:'),
                  onPressed: () {
                    _chooseTime(endTime, false);
                  },
                ),
                Text(
                  '${getTimeString(endTime)}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Text(
              'Select Roles Needed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: AddShiftWidget.roles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: null,
                    ),
                    title: Text(AddShiftWidget.roles[index]),
                    subtitle: Text('1'),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_right),
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
      ),
    );
  }
}
