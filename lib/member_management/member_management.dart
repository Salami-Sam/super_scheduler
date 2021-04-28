import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_individual.dart';
import 'edit_roles.dart';
import 'invite_member.dart';
import '../main.dart';

/* Screen:
 * Edit Members
 * 
 * Writen by Mike Schommer
 * version 2.0
 * 4/14/21
 */

List permissions = ['Member', 'Manager', 'Admin'];
var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
CollectionReference users = db.collection('users');

//standard function to return members from database
Future<Map> getMembers() async {
  Map returnMap;
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['Members'];
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

//deletes member from database map
Future<void> deleteMember(var memberToRemove) async {
  print(memberToRemove);
  await group
      .doc('PCXUSOFVGcmZ8UqK0QnX')
      .update({'Members.${memberToRemove}': FieldValue.delete()});
}

/* EditMemberWidget screen acts like the "main" screen for most member management 
 * screens as it acts as a jumping off point to all other member management screens
 * EditMemberWidget can also allow admins to be able to delete members from group
 * 
 * todo: Should NOT be able to be accessed by members, only admins 
*/
class EditMemberWidget extends StatefulWidget {
  @override
  _EditMemberWidgetState createState() => _EditMemberWidgetState();
}

class _EditMemberWidgetState extends State<EditMemberWidget> {
  Future<Map> futureMembers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Current Members'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); //back to main group screen
            },
          ),
          centerTitle: true,
        ),
        drawer: getUnifiedDrawerWidget(),
        body: Column(children: [
          Flexible(
              child: FutureBuilder<Map>(
                  future: futureMembers = getMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    Map members = snapshot.data;
                    List names =
                        members.keys.toList(); //these are used for printing
                    List roles = members.values
                        .toList(); // easier to use than maps as Lists are naturally indexed
                    return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                            leading: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteMember(names[index]);
                                  setState(() {
                                    //changes state to reflect any deleted member
                                    names.length;
                                  });
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
                                              EditIndividualMemberWidget(
                                                  index:
                                                      index, //index of which member is clicked on
                                                  members: members))).then(
                                      (value) {
                                    setState(
                                        () {}); //this is here to ensure any change on EditIndividualMemberWidget is reflected back here
                                  });
                                })),
                        separatorBuilder: (context, int) =>
                            Divider(thickness: 1.0, height: 1.0),
                        itemCount: names.length);
                  })),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InviteMemberWidget()),
                );
              },
              child: Text('Invite New Members')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditRolesWidget())).then((value) {
                      setState(() {}); //this is here to ensure any change on EditRolesWidget is reflected back here
                    });
              },
              child: Text('Edit Group Roles')),
        ]));
  }
}

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}
