import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';

/* This file contains scheduling-related things that are reused
 * by multiple different parts of the app
 * 
 * Author: Dylan Schulz
 */

const int numDaysInWeek = 7;

// A standard list of tabs for days of the week
final List<Widget> dailyTabList = [
  Tab(text: 'Su'),
  Tab(text: 'M'),
  Tab(text: 'T'),
  Tab(text: 'W'),
  Tab(text: 'Th'),
  Tab(text: 'F'),
  Tab(text: 'Sa'),
];

// Contains left and right arrows on either side of
// the Text that lists the dates of the currently displayed week
Widget getDateNavigationRow() {
  return Consumer<AppStateModel>(
    builder: (context, appStateModel, child) {
      DateTime weekEndDate =
          appStateModel.curWeekStartDate.add(Duration(days: 6));
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              appStateModel.decreaseCurWeekBy1();
            },
          ),
          Text(
            'For the week ${getDateString(appStateModel.curWeekStartDate)} to ${getDateString(weekEndDate)}',
            style: TextStyle(fontSize: 18),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              appStateModel.increaseCurWeekBy1();
            },
          ),
        ],
      );
    },
  );
}

// Gets the title of a screen in the following format:
// screenName: currentGroupRefName
StreamBuilder<DocumentSnapshot> getScreenTitle(
    {@required DocumentReference currentGroupRef,
    @required String screenName}) {
  return StreamBuilder<DocumentSnapshot>(
    stream: currentGroupRef.snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('$screenName');
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return Text('$screenName');
      } else {
        var currentGroup = snapshot.data;
        return Text('$screenName: ${currentGroup['name']}');
      }
    },
  );
}

// Gets text nicely formatted for use in a table in the schedule screens
Widget getFormattedTextForTable(String contents) {
  return Padding(
      child: Text(
        contents,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      padding: EdgeInsets.all(5));
}

// Converts a map of needed roles to a nice String
// rolesMap should be of the type Map<String, int>
String getRoleMapString(Map<String, dynamic> rolesMap) {
  var toReturn = '';
  for (var mapEntry in rolesMap.entries) {
    var role = mapEntry.key;
    var numNeeded = mapEntry.value;
    if (toReturn != '') {
      toReturn = '$toReturn, ';
    }
    toReturn = '$toReturn$role ($numNeeded)';
  }
  return toReturn;
}

// Converts a TimeOfDay into a nice String of the form H:MM AM or H:MM PM
String timeOfDayToTimeString(TimeOfDay time) {
  int hour = time.hourOfPeriod;
  int minute = time.minute;
  DayPeriod amOrPm = time.period;

  String minuteStr = minute < 10 ? '0$minute' : '$minute';
  String amOrPmStr;

  if (amOrPm == DayPeriod.am) {
    amOrPmStr = 'AM';
  } else {
    amOrPmStr = 'PM';
  }

  return '$hour:$minuteStr $amOrPmStr';
}

// Converts a DateTime's time into a nice String of the form H:MM AM or H:MM PM
String dateTimeToTimeString(DateTime time) {
  return timeOfDayToTimeString(TimeOfDay.fromDateTime(time));
}

// Converts a DateTime into a nice String of the form M/D/YY
String getDateString(DateTime date) {
  int twoDigitYear = date.year % 100;
  return '${date.month}/${date.day}/$twoDigitYear';
}

// Get weekly schedule doc, if it exists
// If it does not, return null
Future<DocumentReference> getWeeklyScheduleDoc(
    {@required DocumentReference groupRef, @required DateTime weekStartDate}) {
  var existsQuery = groupRef
      .collection('WeeklySchedules')
      .where('startDate', isEqualTo: Timestamp.fromDate(weekStartDate));
  return existsQuery.get().then((snapshot) {
    if (snapshot.size == 0) {
      // If no WeeklySchedule doc has this start date, it doesn't exist
      return null;
    } else {
      // Return the first and only doc with this date
      return snapshot.docs.first.reference;
    }
  });
}

// Creates a weekly schedule document with the given info
// Returns the created document
Future<DocumentReference> createWeeklyScheduleDoc(
    {@required DocumentReference groupRef, @required DateTime weekStartDate}) {
  var doc = groupRef.collection('WeeklySchedules').doc();
  return doc.set({
    'startDate': Timestamp.fromDate(weekStartDate),
    'published': false,
  }).then((value) => doc);
}

////////////////////////////////////////////////////////////////////////////////

// Used for placeholder dates until the actual model and database are set up
String getRandomTime() {
  var hour = Random().nextInt(12) + 1;
  var minute = Random().nextInt(60);
  var amOrPm = Random().nextBool() ? 'AM' : 'PM';

  return '$hour:$minute $amOrPm';
}

// Used for placeholder names until the actual model and database are set up
String getRandomName() {
  var names = [
    'Spongebob Squarepants',
    'Patrick Star',
    'Squidward Tentacles',
    'Eugene Krabs'
  ];
  return names[Random().nextInt(4)];
}

// Used for placeholder roles until the actual model and database are set up
String getRandomRole() {
  var roles = ['Cashier', 'Fry Cook', 'Busboy', 'GM'];
  return roles[Random().nextInt(4)];
}

// Used for placeholder sets of roles in scheduler
// until the actual model and database are set up
String getRandomRoleset() {
  var roles = ['Cashier', 'Fry Cook', 'Busboy', 'GM'];

  var toReturn = '';
  for (int i = 0; i < Random().nextInt(4) + 1; i++) {
    var role = roles[Random().nextInt(roles.length)];
    toReturn = '$role (${Random().nextInt(2) + 1}), $toReturn';
    roles.remove(role);
  }
  return toReturn.substring(0, toReturn.length - 2);
}
