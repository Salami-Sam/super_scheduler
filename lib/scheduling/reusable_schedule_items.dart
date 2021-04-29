import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model.dart';

/* This file contains utility methods for scheduling-related things
 * and methods that are reused by multiple different scheduling-related
 * parts of the app
 * 
 * Author: Dylan Schulz
 */

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

// The styles for text in the scheduling screens' tables
final TextStyle tableHeadingStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
final TextStyle tableBodyStyle = TextStyle(fontSize: 14);

// The separatorBuilder for the ListView table in the scheduling screens
Widget tableSeparatorBuilder(BuildContext context, int index) {
  // Make the divider right under the header row darker
  var color;
  if (index == 0) {
    color = Colors.black;
  } else {
    color = Colors.grey;
  }
  return Divider(
    color: color,
    thickness: 1.0,
  );
}

// Contains left and right arrows on either side of
// the Text that lists the dates of the currently displayed week
Widget getDateNavigationRow() {
  return Consumer<AppStateModel>(
    builder: (context, appStateModel, child) {
      DateTime weekEndDate = appStateModel.curWeekStartDate.add(Duration(days: 6));
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              appStateModel.decreaseCurWeekBy1();
            },
          ),
          InkWell(
            onLongPress: () {
              appStateModel.resetCurrentWeekToNow();
            },
            child: Text(
              'For the week ${getDateString(appStateModel.curWeekStartDate.toLocal())} ' +
                  'to ${getDateString(weekEndDate.toLocal())}',
              style: TextStyle(fontSize: 18),
            ),
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
FutureBuilder<DocumentSnapshot> getScreenTitle(
    {@required DocumentReference currentGroupRef, @required String screenName}) {
  return FutureBuilder<DocumentSnapshot>(
    future: currentGroupRef.get(),
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

// Converts a TimeOfDay into a nice String of the form H:MM AM or H:MM PM
String timeOfDayToTimeString(TimeOfDay time) {
  int hour = time.hourOfPeriod;
  int minute = time.minute;
  DayPeriod amOrPm = time.period;

  if (hour == 0) {
    hour = 12;
  }

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

// Converts the given weekday int to the name of the day it represents
// A weekday of 0 is Sunday, and a weekday of 6 is Saturday
String weekdayIntToString(int weekday) {
  switch (weekday) {
    case (0):
      return 'Sunday';
    case (1):
      return 'Monday';
    case (2):
      return 'Tuesday';
    case (3):
      return 'Wednesday';
    case (4):
      return 'Thursday';
    case (5):
      return 'Friday';
    case (6):
      return 'Saturday';
    default:
      return 'Error';
  }
}

// When getting the weekday of a DateTime, a number is returned:
// a weekday of 1 is Monday, and a weekday of 7 is Sunday
// This method converts such a number into a more useable format, such that:
// a weekday of 0 is Sunday, and a weekday of 6 is Saturday
int weekdayIntConversion(int weekday) {
  switch (weekday) {
    // Sunday is really the only day that needs to change
    case (DateTime.sunday):
      return 0;
    default:
      return weekday;
  }
}

// A pair where:
// the first item is a DocumentReference for a weekly schedule
// the second item is a boolean for whether that schedule is published or not
class SchedulePublishedPair {
  DocumentReference weeklySchedule;
  bool isPublished;
  SchedulePublishedPair(this.weeklySchedule, this.isPublished);
}

// Get weekly schedule doc, if it exists
// Return a pair of the weekly schedule doc and whether it is published or not
// If it does not exist, return null
Future<SchedulePublishedPair> getWeeklyScheduleDoc(
    {@required DocumentReference groupRef, @required DateTime weekStartDate}) {
  var existsQuery =
      groupRef.collection('WeeklySchedules').where('startDate', isEqualTo: Timestamp.fromDate(weekStartDate));
  return existsQuery.get().then((snapshot) {
    if (snapshot.size == 0) {
      // If no WeeklySchedule doc has this start date, it doesn't exist
      return null;
    } else {
      // Get the first and only doc with this date
      QueryDocumentSnapshot scheduleSnapshot = snapshot.docs.first;
      // Check whether the schedule is published
      bool isPublished = scheduleSnapshot['published'];

      return SchedulePublishedPair(scheduleSnapshot.reference, isPublished);
    }
  });
}

// A 3-tuple where:
// the first item is a QueryDocumentSnapshot of a shift
// the second item is a String representing a role
// the third item is an int representing the number needed of that role
class ShiftRoleTuple {
  QueryDocumentSnapshot shift;
  String role;
  int numNeeded;
  ShiftRoleTuple(this.shift, this.role, this.numNeeded);
}

// Separate the roles that each given shift needs out
// so that you have list of shift-role-numNeeded tuples
List<ShiftRoleTuple> separateIntoShiftRoleTuples(List<QueryDocumentSnapshot> shifts) {
  List<ShiftRoleTuple> shiftRoleTuples = [];
  for (var shift in shifts) {
    var shiftDocData = shift.data();
    Map rolesNeeded = shiftDocData['rolesNeeded'];
    for (MapEntry roleEntry in rolesNeeded.entries) {
      if (roleEntry.value > 0) {
        shiftRoleTuples.add(ShiftRoleTuple(
          shift,
          roleEntry.key,
          roleEntry.value,
        ));
      }
    }
  }
  return shiftRoleTuples;
}

// Gets all users within the given group who have the given role
// The Map contains pairs, where
// the first item is the user's uid
// the second item is the user's displayName
Future<Map<String, String>> getUsersWithRole({@required DocumentReference groupRef, @required String neededRole}) {
  return groupRef.get().then((curGroupSnapshot) {
    return FirebaseFirestore.instance.collection('users').get().then((allUsers) {
      var allUserDocs = allUsers.docs;
      Map<String, String> usersWithRole = {};

      void forEachCallback(userId, userRole) {
        if (userRole == neededRole) {
          var userDoc = allUserDocs.firstWhere((element) => element.id == userId);
          var userDisplayName = userDoc['displayName'];
          usersWithRole[userId] = userDisplayName;
        }
      }

      curGroupSnapshot['Members'].forEach(forEachCallback);
      curGroupSnapshot['Managers'].forEach(forEachCallback);
      curGroupSnapshot['Admins'].forEach(forEachCallback);

      return usersWithRole;
    });
  });
}
