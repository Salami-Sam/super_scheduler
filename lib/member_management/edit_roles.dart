import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/* Screen:
 * Edit Roles
 * 
 * @author Mike Schommer
 * version 3.0
 * 4/28/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');

//EditRolesWidget allows admin to create or deleted roles with a group
class EditRolesWidget extends StatefulWidget {
  final String currentGroupId;
  EditRolesWidget({this.currentGroupId});

  @override
  _EditRolesWidgetState createState() => _EditRolesWidgetState(currentGroupId);
}

class _EditRolesWidgetState extends State<EditRolesWidget> {
  Future<List> futureRoles;
  String newRole = '';
  String currentGroupId;
  _EditRolesWidgetState(this.currentGroupId);

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

//need to not have doc be a string, should be variable
  Future<void> addRoles(var roleToAdd, String currentGroupId) async {
    await group.doc('$currentGroupId').update({
      'roles': FieldValue.arrayUnion([roleToAdd])
    });
  }

//standard function to delete roles from database
  Future<void> deleteRoles(var roleToRemove, String currentGroupId) async {
    await group.doc('$currentGroupId').update({
      'roles': FieldValue.arrayRemove([roleToRemove])
    });
    currentMembersWithNowDeletedRoles(roleToRemove, currentGroupId);
  }

//lists every member whose role has been deleted from deleteRoles
  void currentMembersWithNowDeletedRoles(var roleToRemove, String currentGroupId) async {
    Map members = await getMembers(currentGroupId);
    List currentMembers = members.keys.toList();
    List currentRoles = members.values.toList();
    List updateMembers = [];
    for (int i = 0; i < currentMembers.length; i++) {
      if (currentRoles[i] == roleToRemove) {
        updateMembers.add(currentMembers[i]);
      }
    }
    correctRoles(updateMembers, currentGroupId);
  }

//assigns every member with a deleted role as NA
  Future<void> correctRoles(var updateMembers, String currentGroupId) async {
    for (int i = 0; i < updateMembers.length; i++) {
      await group.doc('$currentGroupId').update({'Members.${updateMembers[i]}': 'N\A'});
    }
  }

//standard function getting members from database
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

  Drawer getUnifiedDrawerWidget() {
    return Drawer(
      child: Text('Drawer placeholder'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Current Roles'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); //back to edit member screen
              },
            )),
        drawer: getUnifiedDrawerWidget(),
        body: Column(children: [
          Flexible(
              child: FutureBuilder<List>(
                  future: futureRoles = getRoles(currentGroupId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    List roles = snapshot.data ?? [];
                    roles.sort((a, b) => a.toUpperCase() != b.toUpperCase()
                        ? a.toUpperCase().compareTo(b.toUpperCase())
                        : a.compareTo(b)); //there is not ignoreCase in flutter so this fixes that issue
                    return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteRoles(roles[index], currentGroupId);
                                    setState(() {}); //resets screen to reflect changes made to database roles array
                                  }),
                              title: Text('${roles[index]}'),
                            ),
                        separatorBuilder: (context, int) => Divider(thickness: 1.0, height: 1.0),
                        itemCount: roles.length);
                  })),
          TextField(
              decoration: InputDecoration(
                  labelText: 'New Role', hintText: 'e.g. Dishwasher, Host, Prep', contentPadding: EdgeInsets.all(20.0)),
              onChanged: (text) {
                newRole = text;
              }),
          ElevatedButton(
              onPressed: () {
                addRoles(newRole, currentGroupId); //sends new role to database
                setState(() {});
              },
              child: Text('Submit'))
        ]));
  }
}
