import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_scheduler/model.dart';
import 'reusable_schedule_items.dart';
import 'finalize_schedule.dart';
import 'add_shift.dart';

/* Screens:
 * Primary Scheduler
 *
 * Author: Dylan Schulz
 */

class PrimarySchedulerWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;

  final String currentGroupId;

  // Need to change to @required and remove default value
  PrimarySchedulerWidget({this.currentGroupId = 'RsTjd6INQsNa6RvSTeUX'});

  @override
  _PrimarySchedulerWidgetState createState() => _PrimarySchedulerWidgetState();
}

class _PrimarySchedulerWidgetState extends State<PrimarySchedulerWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;
  DocumentReference curWeekScheduleDocRef;
  int selectedRowIndex = -1;
  DocumentReference selectedRowShiftDocRef;

  // Converts a map of needed roles to a nice String
  // rolesMap should be of the type Map<String, int>
  String _getRoleMapString(Map<String, dynamic> rolesMap) {
    var toReturn = '';
    for (var mapEntry in rolesMap.entries) {
      var role = mapEntry.key;
      var numNeeded = mapEntry.value;
      // If this role is not needed, don't add it to the String
      if (numNeeded > 0) {
        // Add a separator if this is not the first iteration
        if (toReturn != '') {
          toReturn = '$toReturn, ';
        }
        // Add the value
        toReturn = '$toReturn$role ($numNeeded)';
      }
    }

    if (toReturn == '') {
      return 'No roles needed';
    } else {
      return toReturn;
    }
  }

  // Removes the Shift referred to by selectedRowShiftDocRef,
  // i.e. the shift the user has selected,
  // from the database
  void _removeSelectedShiftFromDb() {
    selectedRowShiftDocRef.delete();
    setState(() {
      selectedRowIndex = -1;
    });
  }

  // Gets the tab with a particular day's information
  Widget _getIndividualTab(DateTime today) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: curWeekScheduleDocRef.collection('Shifts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'There was an error in retrieving the schedule.'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: Text('Retrieving schedule...'));
                } else {
                  var docsList = snapshot.data.docs;

                  // Get only shifts for the current day
                  var todaysShifts = docsList.where((element) {
                    DateTime shiftDate = element['startDateTime'].toDate();
                    if (shiftDate.year == today.year &&
                        shiftDate.month == today.month &&
                        shiftDate.day == today.day) {
                      return true;
                    }
                    return false;
                  }).toList();

                  // Sort the shifts in order of start time
                  todaysShifts.sort((shift1, shift2) {
                    var shift1StartDate = shift1['startDateTime'].toDate();
                    var shift2StartDate = shift2['startDateTime'].toDate();
                    return shift1StartDate.compareTo(shift2StartDate);
                  });

                  if (todaysShifts.isEmpty) {
                    return Center(
                        child: Text('There are no shifts on this day.'));
                  } else {
                    return SingleChildScrollView(
                      child: DataTable(
                        showCheckboxColumn: false,
                        columnSpacing: 20,
                        // make dataRowHeight slightly larger than the default to add
                        // extra padding between rows
                        dataRowHeight: kMinInteractiveDimension + 5,
                        onSelectAll: (val) {
                          // When the user unselects all rows via the checkbox,
                          // unselect the current row in our state
                          setState(() {
                            selectedRowIndex = -1;
                          });
                        },
                        columns: [
                          DataColumn(label: Text('Start')),
                          DataColumn(label: Text('End')),
                          DataColumn(label: Text('Roles')),
                        ],
                        rows: List<DataRow>.generate(
                          todaysShifts.length,
                          (index) {
                            var docData = todaysShifts[index].data();
                            var docRef = todaysShifts[index].reference;
                            var startTime = dateTimeToTimeString(
                                docData['startDateTime'].toDate().toLocal());
                            var endTime = dateTimeToTimeString(
                                docData['endDateTime'].toDate().toLocal());
                            var roleList =
                                _getRoleMapString(docData['rolesNeeded']);

                            return DataRow(
                                cells: [
                                  DataCell(Text(
                                    "$startTime",
                                    maxLines: 1,
                                  )),
                                  DataCell(Text(
                                    "$endTime",
                                    maxLines: 1,
                                  )),
                                  DataCell(Text("$roleList")),
                                ],
                                // Only allow one row to be selected at a time
                                // This row is selected if the currently selected
                                // row index is equal to this row's index
                                selected: selectedRowIndex == index,
                                onSelectChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selectedRowIndex = index;
                                      selectedRowShiftDocRef = docRef;
                                    } else {
                                      selectedRowIndex = -1;
                                      selectedRowShiftDocRef = null;
                                    }
                                  });
                                });
                          },
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ),
        ElevatedButton(
          child: Text('Add Shift'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddShiftWidget(
                  currentGroupId: widget.currentGroupId,
                  curWeekScheduleDocRef: curWeekScheduleDocRef,
                  curDay: today,
                ),
              ),
            );
          },
        ),
        ElevatedButton(
          child: Text('Remove Selected Shift'),
          // Disable the button if no shift is currently selected
          onPressed: (selectedRowShiftDocRef == null)
              ? null
              : _removeSelectedShiftFromDb,
        ),
      ],
    );
  }

  // Return the main contents of this screen
  Widget _getScreenContents(DateTime weekStartDate) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TabBarView(
              children: [
                _getIndividualTab(weekStartDate),
                _getIndividualTab(weekStartDate.add(Duration(days: 1))),
                _getIndividualTab(weekStartDate.add(Duration(days: 2))),
                _getIndividualTab(weekStartDate.add(Duration(days: 3))),
                _getIndividualTab(weekStartDate.add(Duration(days: 4))),
                _getIndividualTab(weekStartDate.add(Duration(days: 5))),
                _getIndividualTab(weekStartDate.add(Duration(days: 6))),
              ],
            ),
          ),
          ElevatedButton(
            child: Text('Finalize Schedule'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FinalizeScheduleWidget(
                    currentGroupId: widget.currentGroupId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    groups = widget.db.collection('groups');
    currentGroupRef = groups.doc(widget.currentGroupId);

    return DefaultTabController(
      length: DateTime.daysPerWeek,
      child: Scaffold(
        appBar: AppBar(
          title: getScreenTitle(
            currentGroupRef: currentGroupRef,
            screenName: 'Scheduler',
          ),
          bottom: TabBar(
            tabs: dailyTabList,
          ),
        ),
        body: Consumer<AppStateModel>(
          builder: (context, appStateModel, child) =>
              FutureBuilder<DocumentReference>(
            future: getWeeklyScheduleDoc(
              groupRef: currentGroupRef,
              weekStartDate: appStateModel.curWeekStartDate,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'There was an error in checking this week\'s schedule.'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Preparing schedule...'));
              } else {
                // Check if the schedule existed when checked
                if (snapshot.data == null) {
                  // Did not exist, so create it in a Future
                  return FutureBuilder<DocumentReference>(
                    future: createWeeklyScheduleDoc(
                      groupRef: currentGroupRef,
                      weekStartDate: appStateModel.curWeekStartDate,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'There was an error in creating this week\'s schedule.'));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: Text('Preparing schedule...'));
                      } else {
                        // Save the schedule ref in a var and return screen contents
                        curWeekScheduleDocRef = snapshot.data;
                        return _getScreenContents(
                            appStateModel.curWeekStartDate);
                      }
                    },
                  );
                } else {
                  // Did exist, so save it in a variable and return screen contents
                  curWeekScheduleDocRef = snapshot.data;
                  return _getScreenContents(appStateModel.curWeekStartDate);
                }
              }
            },
          ),
        ),
        bottomNavigationBar: getDateNavigationRow(),
      ),
    );
  }
}