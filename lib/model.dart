import 'package:flutter/cupertino.dart';

/* This file contains the model for the app state
 * 
 * Authors: Dylan Schulz, Rudy Fisher
 */

// A class to store state data global to the app
class AppStateModel extends ChangeNotifier {
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

/*Future<void> access() async {
  
}*/