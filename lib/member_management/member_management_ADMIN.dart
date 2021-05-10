import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_individualADMIN.dart';
import 'invite_member.dart';
import '../screen_title.dart';

/* Screen:
 * Edit Members
 * 
 * @author Mike Schommer
 * @version 3.0
 * 4/28/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
CollectionReference users = db.collection('users');
List uids;
Map membersMap, managersMap, adminsMap;
String currentPermission;

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

//standard function to return members + managers from database
Future<Map> getAllMembers(String currentGroupId) async {
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

//deletes member from database map
Future<void> deleteMember(var memberToRemove, String currentGroupId) async {
  await group
      .doc('$currentGroupId')
      .update({'Members.$memberToRemove': FieldValue.delete()});
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

/* EditMemberWidget screen acts like the "main" screen for most member management 
 * screens as it acts as a jumping off point to all other member management screens
 * EditMemberWidget can also allow admins to be able to delete members from group
 * 
 * todo: Should NOT be able to be accessed by members, only admins 
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
  _EditMemberAdminWidgetState(this.currentGroupId);

  Drawer getUnifiedDrawerWidget() {
    return Drawer(
      child: Text('Drawer placeholder'),
    );
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
        drawer: getUnifiedDrawerWidget(),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: FutureBuilder<Map>(
                  future: futureMembers = getAllMembers(currentGroupId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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
                                  deleteMember(names[index], currentGroupId);
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
                                              EditIndividualMemberAdminWidget(
                                                  index:
                                                      index, //index of which member is clicked on
                                                  members: members,
                                                  currentGroupId:
                                                      currentGroupId,
                                                  uids: uids))).then((value) {
                                    setState(
                                        () {}); //this is here to ensure any change on EditIndividualMemberWidget is reflected back here
                                  });
                                })),
                        separatorBuilder: (context, int) =>
                            Divider(thickness: 1.0, height: 1.0),
                        itemCount: names.length);
                  })),
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
