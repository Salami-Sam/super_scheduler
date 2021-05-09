import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/* Screen:
 * Edit Individual Member
 * 
 * @author Mike Schommer
 * @version 3.0
 * 4/28/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
CollectionReference users = db.collection('users');

List permissions = ['Member', 'Manager', 'Admin']; //tmp

/*
 * EditIndividualMember is a screen that allows an admin to change a role and 
 * permission level of a specific user and save the changes made to said user
 * 
*/
class EditIndividualMemberAdminWidget extends StatefulWidget {
  final Map members;
  final int index;
  final String currentGroupId;
  EditIndividualMemberAdminWidget(
      {this.members, this.index, this.currentGroupId});

  @override
  _EditIndividualMemberAdminWidgetState createState() =>
      _EditIndividualMemberAdminWidgetState(members, index, currentGroupId);
}

class _EditIndividualMemberAdminWidgetState
    extends State<EditIndividualMemberAdminWidget> {
  Future<Map> futureMembers;
  Future<List> futureRoles;
  List names, roles;
  Map members; //this map is used for the display of member in title box
  String selectedRole,
      selectedPermission,
      currentGroupId; //these strings are used by the drop menu, will see similar strings in other widgets
  int index;
  _EditIndividualMemberAdminWidgetState(
      this.members, this.index, this.currentGroupId);
  //this members map is used for the dropdown menu
  //for some reason the dropdown kept returning null
  //the only way around it was to have two different maps
  //this is fine as the first members map is only used for printing

  List uids; //this stores any uids before they are converted into display names
  String currentPermission;

  //standard function to return roles from database
  Future<List> getRoles(String currentGroupId) async {
    List returnList = [];
    await group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        returnList = docref['roles'];
      } else {
        print("Error, name not found");
      }
    });
    return returnList;
  }

  //standard function to return members + managers from database
  Future<Map> getAllMembers(String currentGroupId) async {
    Map membersMap, managersMap, adminsMap;
    await group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        membersMap = docref['Members'];
        managersMap = docref['Managers'];
        adminsMap = docref['Admins'];
        membersMap.addAll(managersMap);
        membersMap.addAll(adminsMap);
        uids = membersMap.keys.toList();
      } else {
        print("Error, name not found");
      }
    });
    return uidToMembers(membersMap);
  }

  Future<Map> getMembers(String currentGroupId) async {
    Map returnMap;
    await group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        returnMap = docref['Members'];
      } else {
        print("Error, name not found");
      }
    });
    return returnMap;
  }

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

//first finds if the member was a member, manager or admin, then deletes old
//entry in database then replaces entry to the new permission level
  changePermissions(var memberChosen, String newPermission) async {
    Map managersMap = await getManagers(currentGroupId);
    Map adminsMap = await getAdmins(currentGroupId);
    print(managersMap);
    print('new permission $newPermission');
    await group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        if (adminsMap.containsKey(memberChosen)) {
          group
              .doc('$currentGroupId')
              .update({'Admins.$memberChosen': FieldValue.delete()});
          group
              .doc('$currentGroupId')
              .update({'${newPermission}s.$memberChosen': 'N\A'});
        } else if (managersMap.containsKey(memberChosen)) {
          group
              .doc('$currentGroupId')
              .update({'Managers.$memberChosen': FieldValue.delete()});
          group
              .doc('$currentGroupId')
              .update({'${newPermission}s.$memberChosen': 'N\A'});
        } else {
          group
              .doc('$currentGroupId')
              .update({'Members.$memberChosen': FieldValue.delete()});
          group
              .doc('$currentGroupId')
              .update({'${newPermission}s.$memberChosen': 'N\A'});
        }
      } else {
        print("Error, name not found");
      }
    });
  }

  //fetches username from users collection
  //(users collection is collection that stores members from firebase auth)
  Future<String> uidToMembersHelper(var key) async {
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
    return members;
  }

  Future<void> editRole(
      var memberChosen, var newRole, String currentGroupId) async {
    await group
        .doc('$currentGroupId')
        .update({'Members.$memberChosen': '$newRole'});
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
            title: FutureBuilder<Map>(
                future: futureMembers = getAllMembers(currentGroupId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error');
                  }
                  members = snapshot.data;
                  names = members.keys.toList();
                  return Text('${names[index]}');
                }),
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //back to edit member screen screen
                  Navigator.pop(context);
                })),
        drawer: getUnifiedDrawerWidget(),
        body: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ListTile(
              title: Center(
                child: Text('Role',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
              ),
            ),
            FutureBuilder<List>(
                future: futureRoles = getRoles(currentGroupId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error');
                  }
                  List roles = snapshot.data;
                  roles.sort((a, b) => a.toUpperCase() != b.toUpperCase()
                      ? a.toUpperCase().compareTo(b.toUpperCase())
                      : a.compareTo(b)); //sorts roles in drop down menu
                  names = members.keys.toList();
                  return DropdownButton(
                    hint: Text(members['${names[index]}']),
                    value: selectedRole,
                    onChanged: (newRole) {
                      setState(() {
                        editRole(uids[index], newRole, currentGroupId);
                        selectedRole = newRole;
                      });
                    },
                    items: roles.map((role) {
                      return DropdownMenuItem(
                          child: new Text(role), value: role);
                    }).toList(),
                  );
                }),
            // An invisible divider to provide space
            Divider(
                height: 20.0, color: Theme.of(context).scaffoldBackgroundColor),
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
                  changePermissions(uids[index], selectedPermission);
                });
              },
              items: permissions.map((permission) {
                return DropdownMenuItem(
                    child: new Text(permission), value: permission);
              }).toList(),
            )
          ]),
        ));
  }
}
