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
  final String currentGroupId, role;
  final List uids;
  EditIndividualMemberAdminWidget(
      {this.members, this.index, this.currentGroupId, this.uids, this.role});

  @override
  _EditIndividualMemberAdminWidgetState createState() =>
      _EditIndividualMemberAdminWidgetState(
          members, index, currentGroupId, uids, role);
}

class _EditIndividualMemberAdminWidgetState
    extends State<EditIndividualMemberAdminWidget> {
  Future<Map> futureMembers;
  Future<List> futureRoles;
  Future<String> futurePermission;
  List names, roles, uids;
  Map members;
  String selectedRole,
      selectedPermission,
      currentGroupId,
      currentPermission,
      currentRole; //these strings are used by the drop menu, will see similar strings in other widgets
  int index;
  _EditIndividualMemberAdminWidgetState(this.members, this.index,
      this.currentGroupId, this.uids, this.currentRole);

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

  Future<Map> getManagers(String currentGroupId) async {
    Map returnMap;
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
  changePermissions(
      var memberChosen, String newPermission, String currentRole) async {
    if (currentRole == 'null') {
      currentRole = 'NA';
    }
    print(currentRole);
    Map managersMap = await getManagers(currentGroupId);
    Map adminsMap = await getAdmins(currentGroupId);
    await group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        if (adminsMap.containsKey(memberChosen)) {
          group
              .doc('$currentGroupId')
              .update({'Admins.$memberChosen': FieldValue.delete()});
          group
              .doc('$currentGroupId')
              .update({'${newPermission}s.$memberChosen': '$currentRole'});
        } else if (managersMap.containsKey(memberChosen)) {
          group
              .doc('$currentGroupId')
              .update({'Managers.$memberChosen': FieldValue.delete()});
          group
              .doc('$currentGroupId')
              .update({'${newPermission}s.$memberChosen': '$currentRole'});
        } else {
          group
              .doc('$currentGroupId')
              .update({'Members.$memberChosen': FieldValue.delete()});
          group
              .doc('$currentGroupId')
              .update({'${newPermission}s.$memberChosen': '$currentRole'});
        }
      }
    });
  }

  Future<void> editRole(
      var memberChosen, var newRole, String currentGroupId) async {
    String currentPermission =
        await getPermission(currentGroupId, memberChosen);
    await group
        .doc('$currentGroupId')
        .update({'${currentPermission}s.$memberChosen': '$newRole'});
  }

  Drawer getUnifiedDrawerWidget() {
    return Drawer(
      child: Text('Drawer placeholder'),
    );
  }

  String getName(Map members) {
    names = members.keys.toList();
    String longName = '${names[index]}';
    int indexOfParenthesis = longName.indexOf("(");
    String name = longName.substring(0, indexOfParenthesis);
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(getName(members)),
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
                child: Text('Change Assigned Role',
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
                        selectedRole = newRole;
                        editRole(uids[index], newRole, currentGroupId);
                        currentRole = newRole;
                      });
                    },
                    items: roles.map((role) {
                      return DropdownMenuItem(
                          child: new Text(role), value: role);
                    }).toList(),
                  );
                }),
            Divider(
                height: 20.0, color: Theme.of(context).scaffoldBackgroundColor),
            ListTile(
              title: Center(
                child: Text('Change Permissions',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
              ),
            ),
            FutureBuilder<String>(
                future: futurePermission =
                    getPermission(currentGroupId, uids[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error');
                  } else {
                    return DropdownButton(
                      hint: Text('$currentPermission'),
                      value: selectedPermission,
                      onChanged: (newPermissions) {
                        setState(() {
                          selectedPermission = newPermissions;
                          changePermissions(
                              uids[index], selectedPermission, currentRole);
                        });
                      },
                      items: permissions.map((permission) {
                        return DropdownMenuItem(
                            child: new Text(permission), value: permission);
                      }).toList(),
                    );
                  }
                }),
          ]),
        ));
  }
}
