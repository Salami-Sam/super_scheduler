import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_individualADMIN.dart';
import 'invite_member.dart';
import '../screen_title.dart';

/* Screen:
 * Edit Members
 * 
 * @author Mike Schommer
 * @version 4.0
 * 5/12/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
CollectionReference users = db.collection('users');
List uids, names, roles;
Map membersMap, managersMap, adminsMap, allMembersMap;
String currentPermission;

//gets permission of current group member
Future<String> getPermission(String currentGroupId, var memberChosen) async {
  Map membersMap, managersMap;
  await group.doc('$currentGroupId').get().then((docref) {
    if (docref.exists) {
      membersMap = docref['Members'];
      managersMap = docref['Managers'];
      if (membersMap.containsKey(memberChosen)) {
        currentPermission = 'Member';
      } else if (managersMap.containsKey(memberChosen)) {
        currentPermission = 'Manager';
      } else {
        currentPermission = 'Admin';
      }
    }
  });
  return currentPermission;
}

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

//gets all members+managers+admins, saves their uids in a list, converts their uids to their
//display names and then adds what permission level they are next to their name
//the resulting map is sent back to the future builder so it can be listed out.
//also the way this is implemented all members are going to be displayed on screen
//on top, managers are in the middle and admins are on the bottom
Future<Map> getAllMembers(String currentGroupId) async {
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
      uids = allMembersMap.keys.toList(); //save uids before conversion
      allMembersMap =
          await uidToNames(allMembersMap); //convert uids to display names

      allMembersMap =
          permissionAdder(allMembersMap, membersLength, managersLength);
      //convert all display names to display names + permission level
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
  await group.doc('$currentGroupId').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['Managers'];
    }
  });
  return returnMap;
}

//gets admins from database
Future<Map> getAdmins(String currentGroupId) async {
  Map returnMap;
  await group.doc('$currentGroupId').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['Admins'];
    }
  });
  return returnMap;
}

/* EditMemberWidget screen acts like the "main" screen for most member management 
 * screens as it acts as a jumping off point to all other member management screens
 * EditMemberWidget can also allow admins to be able to delete members from group
*/
class EditMemberAdminWidget extends StatefulWidget {
  final String currentGroupId;
  EditMemberAdminWidget({this.currentGroupId});
  @override
  _EditMemberAdminWidgetState createState() =>
      _EditMemberAdminWidgetState(currentGroupId);
}

class _EditMemberAdminWidgetState extends State<EditMemberAdminWidget> {
  Future<Map> futureMembers;
  String currentGroupId;
  Map members;
  _EditMemberAdminWidgetState(this.currentGroupId);

  //shows snackbar without having to be in scaffold
  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  //deletes member from database and rebuilds the screen
  Future<void> deleteMember(
      String currentGroupId, String uidToRemove, int index) async {
    if (FirebaseAuth.instance.currentUser.uid == uidToRemove) {
      showSnackBar(
          message: 'Cannot delete yourself, another admin must delete you');
      //prevents user from deleting themself
    } else {
      String currentPermission =
          await getPermission(currentGroupId, uidToRemove);
      //get current permssion of the deleted member
      //helps finding database much easier
      await group
          .doc('$currentGroupId')
          .update({'${currentPermission}s.$uidToRemove': FieldValue.delete()});
      //deletes user from the group
      await users.doc('$uidToRemove').update({
        'userGroups': FieldValue.arrayRemove([currentGroupId])
        //deletes group from users currents groups list
      });
      setState(() {});
    }
  }

  Widget getList() {
    return FutureBuilder<Map>(
        future: futureMembers = getAllMembers(currentGroupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error');
          } else {
            Map members = snapshot.data;
            List names = members.keys.toList();
            List roles = members.values.toList();
            return ListView.separated(
                itemBuilder: (context, index) => ListTile(
                    leading: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteMember(currentGroupId, uids[index], index);
                          showSnackBar(
                              message:
                                  '${names[index]} was successfully removed');
                        }),
                    title: Text('${names[index]}'),
                    subtitle: Text('${roles[index]}'),
                    trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditIndividualMemberAdminWidget(
                                          index:
                                              index, //index of which member is clicked on
                                          members: members,
                                          currentGroupId: currentGroupId,
                                          uids: uids,
                                          role: roles[index]))).then((value) {
                            setState(
                                () {}); //this is here to ensure any change on EditIndividualMemberWidget is reflected back here
                          });
                        })),
                separatorBuilder: (context, int) =>
                    Divider(thickness: 1.0, height: 1.0),
                itemCount: names.length);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: getScreenTitle(
              currentGroupRef: group.doc(currentGroupId),
              screenName: 'Edit Current Members'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); //back to main group screen
            },
          ),
          centerTitle: true,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: getList()),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InviteMemberWidget(currentGroupId: currentGroupId)),
                  );
                },
                child: Text('Invite New Members')),
          ),
        ]));
  }
}
