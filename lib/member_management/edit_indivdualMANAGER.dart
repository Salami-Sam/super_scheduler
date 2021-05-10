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

/*
 * EditIndividualMember is a screen that allows an admin to change a role and 
 * permission level of a specific user and save the changes made to said user
 * 
*/
class EditIndividualMemberManagerWidget extends StatefulWidget {
  final Map members;
  final int index;
  final String currentGroupId;
  final List uids;
  EditIndividualMemberManagerWidget(
      {this.members, this.index, this.currentGroupId, this.uids});

  @override
  _EditIndividualMemberManagerWidgetState createState() =>
      _EditIndividualMemberManagerWidgetState(members, index, currentGroupId, uids);
}

class _EditIndividualMemberManagerWidgetState
    extends State<EditIndividualMemberManagerWidget> {
  Future<Map> futureMembers;
  Future<List> futureRoles;
  List names, roles, uids;
  Map members; //this map is used for the display of member in title box
  String selectedRole,
      selectedPermission,
      currentGroupId, currentPermission; //these strings are used by the drop menu, will see similar strings in other widgets
  int index;
  _EditIndividualMemberManagerWidgetState(
      this.members, this.index, this.currentGroupId, this.uids);
  //this members map is used for the dropdown menu
  //for some reason the dropdown kept returning null
  //the only way around it was to have two different maps
  //this is fine as the first members map is only used for printing


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
                      : a.compareTo(b));
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
          ]),
        ));
  }
}
