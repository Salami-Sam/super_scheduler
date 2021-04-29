import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'member_management.dart';

/* Screen:
 * Edit Roles
 * 
 * @author Mike Schommer
 * version 3.0
 * 4/28/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');

//standard function to return roles from database
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

//need to not have doc be a string, should be variable
Future<void> addRoles(var roleToAdd) async {
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').update({
    'roles': FieldValue.arrayUnion([roleToAdd])
  });
}

//standard function to delete roles from database
Future<void> deleteRoles(var roleToRemove) async {
  print("${roleToRemove}");
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').update({
    'roles': FieldValue.arrayRemove([roleToRemove])
  });
  print('got Here');
  currentMembersWithNowDeletedRoles(roleToRemove);
}

//lists every member whose role has been deleted from deleteRoles
void currentMembersWithNowDeletedRoles(var roleToRemove) async {
  Map members = await getMembers();
  List currentMembers = members.keys.toList();
  List currentRoles = members.values.toList();
  List updateMembers = [];
  print('in helper');
  print(currentMembers);
  print(currentRoles);
  print(members);
  for (int i = 0; i < currentMembers.length; i++) {
    if (currentRoles[i] == roleToRemove) {
      updateMembers.add(currentMembers[i]);
    }
  }
  print(updateMembers);
  correctRoles(updateMembers);
}

//assigns every member with a deleted role as NA
Future<void> correctRoles(var updateMembers) async {
  for (int i = 0; i < updateMembers.length; i++) {
    await group
        .doc('PCXUSOFVGcmZ8UqK0QnX')
        .update({'Members.${updateMembers[i]}': 'N\A'});
  }
}

//standard function getting members from database
Future<Map> getMembers() async {
  Map returnMap;
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['Members'];
    } else {
      print("Error, name not found");
    }
  });
  return returnMap;
}

//EditRolesWidget allows admin to create or deleted roles with a group
class EditRolesWidget extends StatefulWidget {
  @override
  _EditRolesWidgetState createState() => _EditRolesWidgetState();
}

class _EditRolesWidgetState extends State<EditRolesWidget> {
  Future<List> futureRoles;
  String newRole = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Current Roles'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);   //back to edit member screen
              },
            )),
        drawer: getUnifiedDrawerWidget(),
        body: Column(children: [
          Flexible(
              child: FutureBuilder<List>(
                  future: futureRoles = getRoles(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    List roles = snapshot.data ?? [];
                    return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteRoles(roles[index]);
                                    setState(() {});          //resets screen to reflect changes made to database roles array
                                  }),
                              title: Text('${roles[index]}'),
                            ),
                        separatorBuilder: (context, int) =>
                            Divider(thickness: 1.0, height: 1.0),
                        itemCount: roles.length);
                  })),
          TextField(
              decoration: InputDecoration(
                  labelText: 'New Role',
                  hintText: 'e.g. Dishwasher, Host, Prep',
                  contentPadding: EdgeInsets.all(20.0)),
              onChanged: (text) {
                newRole = text;
              }),
          ElevatedButton(
              onPressed: () {
                addRoles(newRole);    //sends new role to database
                setState(() {});
              },
              child: Text('Submit'))
        ]));
  }
}

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}
