import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reusable_schedule_items.dart';

/* Screens:
 * Add Shift
 *
 * Author: Dylan Schulz
 */

// A widget for adding shifts to the schedule
class AddShiftWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;
  final String currentGroupId;
  // The weekly schedule to add this shift to
  final DocumentReference curWeekScheduleDocRef;
  final DateTime curDay;

  AddShiftWidget({@required this.currentGroupId, @required this.curWeekScheduleDocRef, @required this.curDay});

  @override
  _AddShiftWidgetState createState() => _AddShiftWidgetState();
}

class _AddShiftWidgetState extends State<AddShiftWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;

  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 17, minute: 0);
  Map<String, int> rolesNeeded = {};

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

  // Return the area of the screen that is used for selecting roles needed
  Widget _getRoleSelectorArea() {
    return StreamBuilder<DocumentSnapshot>(
      stream: currentGroupRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('There was an error in retrieving the list of roles.'));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          // Update the list of roles needed by
          // getting the total list of roles,
          // copying those in the total list that were previously stored in rolesNeeded
          // and adding those that weren't
          var roleList = snapshot.data['roles'];
          Map<String, int> newRolesNeeded = {};
          for (String role in roleList) {
            if (rolesNeeded.containsKey(role)) {
              newRolesNeeded[role] = rolesNeeded[role];
            } else {
              newRolesNeeded[role] = 0;
            }
          }
          rolesNeeded = newRolesNeeded;

          // Build this widget with the rolesNeeded
          return ListView.builder(
            itemCount: rolesNeeded.length,
            itemBuilder: (context, index) {
              String thisRole = rolesNeeded.keys.elementAt(index);
              int thisNumNeeded = rolesNeeded.values.elementAt(index);

              // If the current numNeeded is 0,
              // do not let the user decrement anymore
              var onLeftPressCallback;
              if (thisNumNeeded <= 0) {
                onLeftPressCallback = null;
              } else {
                onLeftPressCallback = () {
                  setState(() {
                    rolesNeeded.update(thisRole, (value) => value - 1);
                  });
                };
              }

              return ListTile(
                leading: IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: onLeftPressCallback,
                ),
                title: Text(
                  '$thisRole : $thisNumNeeded',
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {
                    setState(() {
                      rolesNeeded.update(thisRole, (value) => value + 1);
                    });
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  // Attempt to actually add the specified shift to the database
  // Returns true if success, false if not
  bool _addShiftToDb() {
    // Check if start time is less than end time
    if ((startTime.hour > endTime.hour) || (startTime.hour == endTime.hour && startTime.minute >= endTime.minute)) {
      SnackBar snackBar = SnackBar(content: Text('Start time must be before end time.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    } else {
      var shiftDoc = widget.curWeekScheduleDocRef.collection('Shifts').doc();
      DateTime startDateTime =
          DateTime(widget.curDay.year, widget.curDay.month, widget.curDay.day, startTime.hour, startTime.minute)
              .toUtc();
      DateTime endDateTime =
          DateTime(widget.curDay.year, widget.curDay.month, widget.curDay.day, endTime.hour, endTime.minute).toUtc();

      shiftDoc.set({
        'startDateTime': Timestamp.fromDate(startDateTime),
        'endDateTime': Timestamp.fromDate(endDateTime),
        'rolesNeeded': rolesNeeded,
        'assignees': [],
        'unavailableUsers': [],
      });

      return true;
    }
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
                  '${timeOfDayToTimeString(startTime)}',
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
                  '${timeOfDayToTimeString(endTime)}',
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
              child: _getRoleSelectorArea(),
            ),
            ElevatedButton(
              child: Text('Add Shift'),
              onPressed: () {
                // Pop back to previous screen if adding shift is successful
                if (_addShiftToDb() == true) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
