import 'package:flutter/cupertino.dart';

/* This file contains models for the app state
 * 
 * Authors: Dylan Schulz, Rudy Fisher
 */

// A class to store state data for all scheduling screens
class SchedulingStateModel extends ChangeNotifier {
  DateTime _weekStartDate = _getSundayMidnightOfThisWeek();

  DateTime get curWeekStartDate => _weekStartDate;

  void increaseCurWeekBy1() {
    _weekStartDate = _weekStartDate.add(Duration(days: 7));
    notifyListeners();
  }

  void decreaseCurWeekBy1() {
    _weekStartDate = _weekStartDate.subtract(Duration(days: 7));
    notifyListeners();
  }

  void resetCurrentWeekToNow() {
    _weekStartDate = _getSundayMidnightOfThisWeek();
    notifyListeners();
  }
}

// Gets Sunday at midnight (morning) of the current week according to DateTime.now()
// Considers Sunday to be the first day of the week
DateTime _getSundayMidnightOfThisWeek() {
  var correctDay = DateTime.now().toUtc();
  while (correctDay.weekday != DateTime.sunday) {
    print(correctDay);
    correctDay = correctDay.subtract(Duration(days: 1));
  }
  return DateTime(correctDay.year, correctDay.month, correctDay.day).toUtc();
}


// Turns out the below thing is not necessary,
// but keeping it just in case

// // A class to store state data keeping track of the currently signed in user
// class CurrentUserStateModel extends ChangeNotifier {
//   String currentUserId = FirebaseAuth.instance.currentUser.uid;
//   String get currentUid => currentUserId;

//   // When the model is created, add a listener to FirebaseAuth
//   // that is called every time the user's signed-in status changes
//   CurrentUserStateModel() {
//     FirebaseAuth.instance.authStateChanges().listen(resetUid);
//   }

//   // Resets the field to the uid of the signed in user and notifies widgets
//   void resetUid(User user) {
//     if (user != null) {
//       currentUserId = user.uid;
//     } else {
//       currentUserId = '';
//     }

//     notifyListeners();
//   }
// }
