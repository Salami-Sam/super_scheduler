import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';

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
Row getDateNavigationRow(DateTime weekStartDate) {
  DateTime weekEndDate = weekStartDate.add(Duration(days: 6));
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: Icon(Icons.arrow_left),
        onPressed: null,
      ),
      Text(
        'For the week ${getDateString(weekStartDate)} to ${getDateString(weekEndDate)}',
        style: TextStyle(fontSize: 18),
      ),
      IconButton(
        icon: Icon(Icons.arrow_right),
        onPressed: null,
      ),
    ],
  );
}

//
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

// Converts a TimeOfDay into a nice String of the form H:MM AM or H:MM PM
String getTimeString(TimeOfDay time) {
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

// Gets Sunday at midnight (morning) of the current week according to DateTime.now()
// Considers Sunday to be the first day of the week
DateTime getSundayMidnightOfThisWeek() {
  var correctDay = DateTime.now();
  while (correctDay.weekday != DateTime.sunday) {
    print(correctDay);
    correctDay = correctDay.subtract(Duration(days: 1));
  }
  return DateTime(correctDay.year, correctDay.month, correctDay.day);
}

// Converts a DateTime into a nice String of the form M/D/YY
String getDateString(DateTime date) {
  int twoDigitYear = date.year % 100;
  return '${date.month}/${date.day}/$twoDigitYear';
}

// Creates a weekly schedule document with the given info,
// if it does not already exist
void createWeeklyScheduleDoc(
    {@required DocumentReference groupRef, @required DateTime weekStartDate}) {
  // First see if the document already exists
  var query = groupRef
      .collection('WeeklySchedules')
      .where('startDate', isEqualTo: Timestamp.fromDate(weekStartDate));
  query.get().then((snapshot) {
    if (snapshot.size == 0) {
      // If it does not exist, create it
      groupRef.collection('WeeklySchedules').doc().set({
        'startDate': Timestamp.fromDate(weekStartDate),
        'published': false,
      });
    }
  });
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
