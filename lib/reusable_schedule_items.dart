import 'dart:math';
import 'package:flutter/material.dart';

/* This file contains scheduling-related things that are reused
 * by multiple different parts of the app
 * 
 * Author: Dylan Schulz
 */

const int numDaysInWeek = 7;

// Contains left and right arrows on either side of
// the Text that lists the dates of the currently displayed week
class DateNavigationRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: null,
        ),
        Text(
          'For the week 3/14/21 to 3/20/21',
          style: TextStyle(fontSize: 20),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: null,
        ),
      ],
    );
  }
}

// Gets text nicely formatted for use in a table
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
