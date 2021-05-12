import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/member_management/member_managementMANAGER.dart';

import '../screen_title.dart';

/* Screen:
 * Edit Roles
 * 
 * @author Mike Schommer
 * version 4.0
 * 5/12/21
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
      }
    });
    return returnList;
  }

  //add roles to database arr
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
  void currentMembersWithNowDeletedRoles(
      var roleToRemove, String currentGroupId) async {
    Map members = await getMembers(currentGroupId);
    Map managers = await getManagers(currentGroupId);
    Map admins = await getAdmins(currentGroupId);
    Map allMembers;

    int membersLength;
    if (members.length == null) {
      membersLength = 0;
    } else {
      membersLength = members.length;
    }
    //find # of members

    int managersLength;
    if (managers.length == null) {
      managersLength = 0;
    } else {
      managersLength = managers.length;
    }
    //find # of managers

    allMembers = members;
    allMembers.addAll(managers);
    allMembers.addAll(admins);

    List currentMembers = allMembers.keys.toList();
    List currentRoles = allMembers.values.toList();
    for (int i = 0; i < currentMembers.length; i++) {
      if (currentRoles[i] == roleToRemove) {
        //if the current group member has a role that has been deleted, find
        //them in database and correct it
        if (i < membersLength) {
          correctRoles(currentMembers[i], currentGroupId, 'Members');
        } else if (i < managersLength + membersLength) {
          correctRoles(currentMembers[i], currentGroupId, 'Managers');
        } else {
          correctRoles(currentMembers[i], currentGroupId, 'Admins');
        }
      }
    }
  }

//assigns every member with a deleted role as NA
  Future<void> correctRoles(String updateMember, String currentGroupId,
      String permissionLevel) async {
    await group
        .doc('$currentGroupId')
        .update({'$permissionLevel.$updateMember': 'NA'});
  }

//standard function getting members from database
  Future<Map> getMembers(String currentGroupId) async {
    Map returnMap;
    await group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        returnMap = docref['Members'];
      }
    });
    return returnMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: getScreenTitle(
                currentGroupRef: group.doc(currentGroupId),
                screenName: 'Current Roles'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(
                    context); //back to either member_managementADMIN or member_managementMANAGER
              },
            )),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: FutureBuilder<List>(
                  future: futureRoles = getRoles(currentGroupId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    List roles = snapshot.data ?? [];
                    roles.sort((a, b) => a.toUpperCase() != b.toUpperCase()
                        ? a.toUpperCase().compareTo(b.toUpperCase())
                        : a.compareTo(
                            b)); //there is not ignoreCase in flutter so this fixes that issue
                    return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteRoles(roles[index], currentGroupId);
                                    setState(
                                        () {}); //resets screen to reflect changes made to database roles array
                                  }),
                              title: Text('${roles[index]}'),
                            ),
                        separatorBuilder: (context, int) =>
                            Divider(thickness: 1.0, height: 1.0),
                        itemCount: roles.length);
                  })),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            child: TextField(
                decoration: InputDecoration(
                    labelText: 'New Role',
                    hintText: 'e.g. Dishwasher, Host, Prep',
                    contentPadding: EdgeInsets.all(20.0)),
                onChanged: (text) {
                  newRole = text;
                }),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed: () {
                  addRoles(
                      newRole, currentGroupId); //sends new role to database
                  setState(() {});
                },
                child: Text('Submit')),
          )
        ]));
  }
}
