import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screen_title.dart';

/* Screen:
 * View Members
 * 
 * @author Mike Schommer
 * @version 3.0
 * 4/28/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
CollectionReference users = db.collection('users');

/* ViewMembersWidget is a screen that displays members of a particular group
 */

class ViewMembersWidget extends StatefulWidget {
  final String currentGroupId;
  ViewMembersWidget({this.currentGroupId});

  @override
  _ViewMembersWidgetState createState() =>
      _ViewMembersWidgetState(currentGroupId);
}

class _ViewMembersWidgetState extends State<ViewMembersWidget> {
  Future<Map> futureMembers;
  String currentGroupId;
  _ViewMembersWidgetState(this.currentGroupId);

//this method adds permission level to end of display name for displaying on screen
Map permissionAdder(Map map, int memberLength, int managerLength) {
  List keys = map.keys.toList();
  List values = map.values
      .toList(); //convert to lists so its easier to index into from a for loop (for me at least)
  map.clear();
  for (int i = 0; i < keys.length; i++) {
    if (i < memberLength) {
      //if i < the number of members, we must be looking at a member
      keys[i] = keys[i] + ' (Member)';
      map[keys[i]] = values[i];
    } else if (i < managerLength + memberLength) {
      keys[i] = keys[i] +
          ' (Manager)'; //if i < the number of members + managers, we must be looking at a manager
      map[keys[i]] = values[i];
    } else {
      keys[i] = keys[i] +
          ' (Admin)'; //if i > the number of members + managers, we must be looking at an admin
      map[keys[i]] = values[i];
    }
  }
  return map;
}

//gets all members+managers+admins, saves their uids, converts their uids to their
//display names and then adds what permission level they are next to their name
//the resulting map is sent back to the future builder so it can be listed out.
//also the way this is implemented all members are
//on top, managers are in the middle and admins are on the bottom
Future<Map> getAllMembers(String currentGroupId) async {
  Map allMembersMap, membersMap, managersMap, adminsMap;
  await group.doc('$currentGroupId').get().then((docref) async {
    if (docref.exists) {
      membersMap = docref['Members'];
      managersMap = docref['Managers'];
      adminsMap =
          docref['Admins']; //get every group member in their respective map
      int membersLength = membersMap.length;
      int managersLength =
          managersMap.length; //save number of people in each permission level

      allMembersMap = membersMap;
      allMembersMap.addAll(managersMap);
      allMembersMap
          .addAll(adminsMap); //combine all members/managers/admins into one map
      allMembersMap =
          await uidToNames(allMembersMap); //convert uids to display names

      allMembersMap =
          permissionAdder(allMembersMap, membersLength, managersLength);
      //convert all display names to display names + permission level
    } else {
      print("Error, name not found");
    }
  });
  return allMembersMap;
}

//fetches username from users collection
//(users collection is collection that stores members from firebase auth)
Future<String> uidToNamesHelper(var key) async {
  String returnString;
  await users.doc(key).get().then((docref) {
    if (docref.exists) {
      returnString = docref['displayName'];
    } else {
      print("Error, name not found");
    }
  });
  return returnString;
}

//converts database map uids to names
Future<Map> uidToNames(Map members) async {
  List keys = members.keys.toList();
  String displayName = '';
  for (int i = 0; i < keys.length; i++) {
    if (members.containsKey(keys[i])) {
      displayName = await uidToNamesHelper(keys[i]);
      String role = members[keys[i]];
      members.remove(keys[i]);
      members['$displayName'] = role;
    }
  }
  return members;
}

//gets managers from database
Future<Map> getManagers(String currentGroupId) async {
  Map returnMap;
  print('in Get managers');
  await group.doc('$currentGroupId').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['Managers'];
    } else {
      print("Error, name not found");
    }
  });
  return returnMap;
}

Future<Map> getAdmins(String currentGroupId) async {
  Map returnMap;
  print('in Get admins');
  await group.doc('$currentGroupId').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['Admins'];
    } else {
      print("Error, name not found");
    }
  });
  return returnMap;
}

  Drawer getUnifiedDrawerWidget() {
    return Drawer(
      child: Text('Drawer placeholder'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: getScreenTitle(
              currentGroupRef: group.doc(currentGroupId),
              screenName: 'Members'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //back to group main page
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        drawer: getUnifiedDrawerWidget(),
        body: FutureBuilder<Map>(
            future: futureMembers = getAllMembers(currentGroupId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error');
              }
              Map members = snapshot.data;
              List names = members.keys.toList();
              List roles = members.values.toList();
              return ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        title: Text('${names[index]}'),
                        subtitle: Text('${roles[index]}'),
                      ),
                  separatorBuilder: (context, int) =>
                      Divider(thickness: 1.0, height: 1.0),
                  itemCount: roles.length);
            }));
  }
}
