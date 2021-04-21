import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main.dart';
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
List roles = ['Cook', 'Cashier', 'Busboy'];
List groupMembers = ['Spongebob', 'Squidward', 'Patrick'];  //these are placeholders
List permissions = ['Member', 'Manager', 'Admin'];

Future<List> getRoles() async {
  List returnList = [];
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnList = docref['roles'];
      print(returnList);
    } else {
      print("Error, name not found");
    }
  });
  return returnList;
}

/*
 * EditIndividualMember is a screen that allows an admin to change a role and 
 * permission level of a specific user and save the changes made to said user
 * 
*/
class EditIndividualMemberWidget extends StatefulWidget {
  final int index;
  EditIndividualMemberWidget({this.index});

  @override
  _EditIndividualMemberWidgetState createState() =>
      _EditIndividualMemberWidgetState(index);
}

class _EditIndividualMemberWidgetState
    extends State<EditIndividualMemberWidget> {
  int index;
  _EditIndividualMemberWidgetState(this.index);
  //these strings are used by the drop menu, will see similar strings in other widgets
  String selectedRole;
  String selectedPermission;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('${groupMembers[index]}'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //back to edit member screen screen
                  Navigator.pop(context);
                })),
        drawer: getUnifiedDrawerWidget(),
        body: Column(
          children: [
            ListTile(
              title: Center(
                child: Text('Role',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
              ),
            ),
            //todo: need to find way to assign whatever is chosen from dropdown to user
            //this will come once users are properly implemented
            DropdownButton(
              hint: Text('${roles[index]}'),
              value: selectedRole,
              onChanged: (newRole) {
                setState(() {
                  selectedRole = newRole;
                });
              },
              items: roles.map((role) {
                return DropdownMenuItem(child: new Text(role), value: role);
              }).toList(),
            ),
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
          ],
        ));
  }
}

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}
