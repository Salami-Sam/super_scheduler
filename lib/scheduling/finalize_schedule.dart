import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main_schedule.dart';
import 'reusable_schedule_items.dart';
import '../screen_title.dart';

/* Screens:
 * Finalize Schedule
 * 
 * Author: Dylan Schulz
 */

class FinalizeScheduleWidget extends StatefulWidget {
  final db = FirebaseFirestore.instance;
  final String currentGroupId;
  final DocumentReference curWeekScheduleDocRef;
  final DateTime weekStartDate;

  FinalizeScheduleWidget(
      {@required this.currentGroupId,
      @required this.curWeekScheduleDocRef,
      @required this.weekStartDate});

  @override
  _FinalizeScheduleWidgetState createState() => _FinalizeScheduleWidgetState();
}

class _FinalizeScheduleWidgetState extends State<FinalizeScheduleWidget> {
  CollectionReference groups;
  DocumentReference currentGroupRef;
  int selectedRowIndex = -1;
  DocumentReference selectedRowShiftDocRef;
  String selectedRowRole;
  int selectedRowNumNeeded;

  // Assigns or unassigns the user with userId
  // to the currently selected shift, referred to by selectedRowShiftDocRef
  // if assign is true, assigns the user
  // if assign is false, unassigns the user
  void _assignOrUnassignUserToShift(String userId, bool assign) {
    selectedRowShiftDocRef.get().then((doc) {
      List assignees = doc['assignees'];
      if (assign == true) {
        assignees.add(userId);
      } else {
        assignees.remove(userId);
      }
      selectedRowShiftDocRef.update({'assignees': assignees});
    });
  }

  // Authors: Dylan Schulz and Rudy Fisher
  void _publishSchedule() async {
    widget.curWeekScheduleDocRef.update({'published': true});

    // Get all the users in the current group.
    Map<String, dynamic> members = (await currentGroupRef.get())['Members'];
    Map<String, dynamic> managers = (await currentGroupRef.get())['Managers'];
    Map<String, dynamic> admins = (await currentGroupRef.get())['Admins'];

    // Send the notification to each of the users in the group.
    _notifyUsers(members);
    _notifyUsers(managers);
    _notifyUsers(admins);
  }

  // Authors: Rudy Fisher and Dylan Schulz
  ///Sends a notification about the posted schedule to the given
  ///[users] in the current group.
  ///[users] should be a Map<String, String>
  void _notifyUsers(Map<String, dynamic> users) async {
    for (String userID in users.keys) {
      // This is the notification contents and what-not.
      Map<String, dynamic> data = {
        'groupId': widget.currentGroupId,
        'content':
            'A new schedule has been posted for the week of ${getDateString(widget.weekStartDate.toLocal())}.',
        'isInvite': false,
      };

      // Send the notification to the user's document in firestore.
      widget.db
          .collection('users')
          .doc(userID)
          .collection('notifications')
          .add(data);
    }
  }

  // Gets the tab with a particular day's information
  Widget _getIndividualTab(DateTime today) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.curWeekScheduleDocRef.collection('Shifts').snapshots(),
        builder: (context, shiftSnapshot) {
          if (shiftSnapshot.hasError) {
            return Center(
                child: Text('There was an error in retrieving the schedule.'));
          } else if (shiftSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            var docsList = shiftSnapshot.data.docs;

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
              return Center(child: Text('There are no shifts on this day.'));
            }

            // Separate the roles that each shift needs out
            // so that you have list of shift-role-numNeeded tuples
            List<ShiftRoleTuple> shiftRoleTuples =
                separateIntoShiftRoleTuples(todaysShifts);

            // The actual schedule part

            return Column(
              children: [
                Expanded(
                  flex: 2, // 2/3 of the available space
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: ListView.separated(
                      itemCount: shiftRoleTuples.length + 1,
                      separatorBuilder: tableSeparatorBuilder,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Create the header row
                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text('Start', style: tableHeadingStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('End', style: tableHeadingStyle),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text('Role', style: tableHeadingStyle),
                              ),
                              Expanded(
                                flex: 3,
                                child:
                                    Text('Assignees', style: tableHeadingStyle),
                              ),
                            ],
                          );
                        }
                        index--; // To account for the header row index

                        var shiftRoleTuple = shiftRoleTuples[index];

                        var shiftDocData = shiftRoleTuple.shift.data();
                        var shiftDocRef = shiftRoleTuple.shift.reference;
                        var role = shiftRoleTuple.role;
                        var numNeeded = shiftRoleTuple.numNeeded;

                        var startTime = dateTimeToTimeString(
                            shiftDocData['startDateTime'].toDate().toLocal());
                        var endTime = dateTimeToTimeString(
                            shiftDocData['endDateTime'].toDate().toLocal());
                        List allAssignees = shiftDocData['assignees'];

                        // If the row is selected, change its background color
                        var rowBackgroundColor;
                        if (index == selectedRowIndex) {
                          rowBackgroundColor = Colors.lightBlue[100];
                        } else {
                          // The default color
                          rowBackgroundColor =
                              Theme.of(context).scaffoldBackgroundColor;
                        }

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedRowIndex = index;
                              selectedRowShiftDocRef = shiftDocRef;
                              selectedRowRole = role;
                              selectedRowNumNeeded = numNeeded;
                            });
                          },
                          child: Container(
                            color: rowBackgroundColor,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child:
                                      Text('$startTime', style: tableBodyStyle),
                                ),
                                Expanded(
                                  flex: 2,
                                  child:
                                      Text('$endTime', style: tableBodyStyle),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('$role ($numNeeded)',
                                      style: tableBodyStyle),
                                ),
                                Expanded(
                                  flex: 3,
                                  // Need to get the list of display names of only assignees with this role
                                  child: FutureBuilder<Map<String, String>>(
                                    future: getUsersWithRole(
                                        groupRef: currentGroupRef,
                                        neededRole: role),
                                    builder: (context, usersSnapshot) {
                                      if (usersSnapshot.hasError) {
                                        return Text('Error.',
                                            style: tableBodyStyle);
                                      } else if (usersSnapshot
                                              .connectionState ==
                                          ConnectionState.waiting) {
                                        return Text('Retrieving...',
                                            style: tableBodyStyle);
                                      } else {
                                        // Get map of users with the role for the shift
                                        Map<String, String> users =
                                            usersSnapshot.data;

                                        // Remove users from this list who are not assigned to this shift
                                        users.removeWhere((key, value) =>
                                            allAssignees.contains(key) ==
                                            false);

                                        if (users.isEmpty) {
                                          return Text('');
                                        }
                                        return Text(
                                            users.values.toList().join(', '),
                                            style: tableBodyStyle);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // The selector area for choosing assignees
                Expanded(
                  flex: 1, // 1/3 of the available space
                  child: FutureBuilder<Map<String, String>>(
                      future: getUsersWithRole(
                          groupRef: currentGroupRef,
                          neededRole: selectedRowRole),
                      builder: (context, usersSnapshot) {
                        if (selectedRowIndex == -1) {
                          return Center(
                              child: Text('Select a shift to assign members.'));
                        } else if (usersSnapshot.hasError) {
                          return Center(
                              child: Text(
                                  'There was an error in retrieving the list of members.'));
                        } else if (usersSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          // Get map of users with the role for the selected row
                          Map<String, String> usersWithRole =
                              usersSnapshot.data;

                          if (usersWithRole.isEmpty) {
                            return Center(
                                child: Text(
                                    'There are no members with the necessary role.'));
                          }

                          var thisShift =
                              shiftRoleTuples[selectedRowIndex].shift;
                          List unavailableUsers = thisShift['unavailableUsers'];
                          List assignees = thisShift['assignees'];

                          // Get a list of the assignees that have the needed role
                          List assigneesWithRole = [];
                          assigneesWithRole.addAll(usersWithRole.keys);
                          assigneesWithRole.removeWhere(
                              (element) => !assignees.contains(element));

                          return ListView.builder(
                            itemCount: usersWithRole.length,
                            itemBuilder: (context, index) {
                              var userMapEntry =
                                  usersWithRole.entries.elementAt(index);

                              var title;
                              var subtitle;
                              if (unavailableUsers.contains(userMapEntry.key)) {
                                title = Text(
                                  '${userMapEntry.value}',
                                  style: TextStyle(color: Colors.redAccent),
                                );
                                subtitle = Text(
                                  'Unavailable',
                                  style: TextStyle(color: Colors.redAccent),
                                );
                              } else {
                                title = Text('${userMapEntry.value}');
                                subtitle = null;
                              }

                              return Theme(
                                data: ThemeData(
                                  visualDensity: VisualDensity(
                                    // Make tiles closer together than by default
                                    vertical: -3,
                                  ),
                                ),
                                child: CheckboxListTile(
                                  value: assignees.contains(userMapEntry.key),
                                  onChanged: (isSelected) {
                                    if (isSelected == true &&
                                        assigneesWithRole.length ==
                                            selectedRowNumNeeded) {
                                      // Don't assign this user because the max number of assignments
                                      // has been reached
                                      SnackBar snackBar = SnackBar(
                                          content: Text(
                                              'No more users with that role are needed.'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      _assignOrUnassignUserToShift(
                                          userMapEntry.key, isSelected);
                                    }
                                  },
                                  title: title,
                                  subtitle: subtitle,
                                ),
                              );
                            },
                          );
                        }
                      }),
                ),
              ],
            );
          }
        });
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
            onTap: (num) {
              setState(() {
                selectedRowIndex = -1;
                selectedRowShiftDocRef = null;
                selectedRowRole = "";
                selectedRowNumNeeded = -1;
              });
            },
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TabBarView(
                  // Disable swiping between tabs because I can't find a simple way
                  // to reset the selectedRowIndex when swiping to a new tab
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _getIndividualTab(widget.weekStartDate),
                    _getIndividualTab(
                        widget.weekStartDate.add(Duration(days: 1))),
                    _getIndividualTab(
                        widget.weekStartDate.add(Duration(days: 2))),
                    _getIndividualTab(
                        widget.weekStartDate.add(Duration(days: 3))),
                    _getIndividualTab(
                        widget.weekStartDate.add(Duration(days: 4))),
                    _getIndividualTab(
                        widget.weekStartDate.add(Duration(days: 5))),
                    _getIndividualTab(
                        widget.weekStartDate.add(Duration(days: 6))),
                  ],
                ),
              ),
              ElevatedButton(
                child: Text('Publish Schedule'),
                onPressed: () {
                  _publishSchedule();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScheduleWidget(
                          currentGroupId: widget.currentGroupId),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
