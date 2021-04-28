import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'member_management.dart';

/* Screen:
 * Edit Individual Member
 * 
 * Writen by Mike Schommer
 * version 2.0
 * 4/14/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
CollectionReference users = db.collection('users');

List permissions = ['Member', 'Manager', 'Admin']; //tmp
List uids;  //this stores any uids before they are converted into display names

//standard function to return roles from database
Future<List> getRoles() async {
  List returnList = [];
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnList = docref['roles'];
      print("in getRoles() " + "$returnList");
    } else {
      print("Error, name not found");
    }
  });
  return returnList;
}

//standard function to return members from database
Future<Map> getMembers() async {
  Map returnMap;
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['Members'];
      uids = returnMap.keys.toList();
      print("in getMembers()");
      print(returnMap);
    } else {
      print("Error, name not found");
    }
  });
  return uidToMembers(returnMap);
}

//fetches username from users collection 
//(users collection is collection that stores members from firebase auth)
Future<String> uidToMembersHelper(var key) async {
  String returnString;
  await users.doc(key).get().then((docref) {
    if (docref.exists) {
      returnString = docref['displayName'];
      print(returnString);
    } else {
      print("Error, name not found");
    }
  });
  return returnString;
}

//converts database map uids to names
Future<Map> uidToMembers(Map members) async {
  List keys = members.keys.toList();
  String displayName = '';
  for (int i = 0; i < keys.length; i++) {
    if (members.containsKey(keys[i])) {
      displayName = await uidToMembersHelper(keys[i]);
      String role = members[keys[i]];
      members.remove(keys[i]);
      members['$displayName'] = role;
    }
  }
  print(members);
  return members;
}

Future<void> editRole(var memberChosen, var newRole) async {
  print(memberChosen);
  print(newRole);
  await group
      .doc('PCXUSOFVGcmZ8UqK0QnX')
      .update({'Members.$memberChosen': '$newRole'});
}

/*
 * EditIndividualMember is a screen that allows an admin to change a role and 
 * permission level of a specific user and save the changes made to said user
 * 
*/
class EditIndividualMemberWidget extends StatefulWidget {
  final Map members;
  final int index;
  EditIndividualMemberWidget({this.members, this.index});

  @override
  _EditIndividualMemberWidgetState createState() =>
      _EditIndividualMemberWidgetState(members, index);
}

class _EditIndividualMemberWidgetState
    extends State<EditIndividualMemberWidget> {
  Future<Map> futureMembers;
  Future<List> futureRoles;
  List names, roles;
  Map members;                                  //this map is used for the display of member in title box
  String selectedRole, selectedPermission;      //these strings are used by the drop menu, will see similar strings in other widgets
  int index;
  _EditIndividualMemberWidgetState(this.members, this.index);    //this members map is used for the dropdown menu
  @override                                                      //for some reason the dropdown kept returning null
  Widget build(BuildContext context) {                           //the only way around it was to have two different maps
    return Scaffold(                                             //this is fine as the first members map is only used for printing
        appBar: AppBar(
            title: FutureBuilder<Map>(
                future: futureMembers = getMembers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error');
                  }
                  members = snapshot.data;
                  //print("in title " + "$members");
                  names = members.keys.toList();
                  return Text('${names[index]}');
                }), centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //back to edit member screen screen
                  Navigator.pop(context);
                })),
        drawer: getUnifiedDrawerWidget(),
        body: Column(children: [
          ListTile(
            title: Center(
              child: Text('Role',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            ),
          ),
          FutureBuilder<List>(
              future: futureRoles = getRoles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error');
                }
                List roles = snapshot.data;
                //print("in dropdown " + "$members");
                names = members.keys.toList();
                //print("in dropdown " + 'members[${names[index]}');
                return DropdownButton(
                  hint: Text(members['${names[index]}']),
                  value: selectedRole,
                  onChanged: (newRole) {
                    setState(() {
                      print('in role change drop menu\n');
                      print(uids);
                      editRole(uids[index], newRole);
                      selectedRole = newRole;
                    });
                  },
                  items: roles.map((role) {
                    return DropdownMenuItem(child: new Text(role), value: role);
                  }).toList(),
                );
              }),
          ListTile(
            title: Center(
              child: Text('Permissions',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            ),
          ),
          DropdownButton(
            hint: Text('${permissions[0]}'),
            value: selectedPermission,
            onChanged: (newPermissions) {
              setState(() {
                selectedPermission = newPermissions;
              });
            },
            items: permissions.map((permission) {
              return DropdownMenuItem(
                  child: new Text(permission), value: permission);
            }).toList(),
          )
        ]));
  }
}

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}
