import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screen_title.dart';

/* Screen:
 * View Members
 * 
 * @author Mike Schommer
 * @version 3.0
 * 4/28/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
CollectionReference users = db.collection('users');

/* ViewMembersWidget is a screen that displays members of a particular group
 */

class ViewMembersWidget extends StatefulWidget {
  final String currentGroupId;
  ViewMembersWidget({this.currentGroupId});

  @override
  _ViewMembersWidgetState createState() =>
      _ViewMembersWidgetState(currentGroupId);
}

class _ViewMembersWidgetState extends State<ViewMembersWidget> {
  Future<Map> futureMembers;
  String currentGroupId;
  _ViewMembersWidgetState(this.currentGroupId);

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
      } else {
        print("Error, name not found");
      }
    });
    return uidToMembers(membersMap);
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

  //standard function to return members from database
  Future<Map> getMembers(String currentGroupId) async {
    Map returnMap;
    await group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        returnMap = docref['Members'];
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
              screenName: 'Members'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //back to group main page
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        drawer: getUnifiedDrawerWidget(),
        body: FutureBuilder<Map>(
            future: futureMembers = getAllMembers(currentGroupId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error');
              }
              Map members = snapshot.data;
              List names = members.keys.toList();
              List roles = members.values.toList();
              return ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        title: Text('${names[index]}'),
                        subtitle: Text('${roles[index]}'),
                      ),
                  separatorBuilder: (context, int) =>
                      Divider(thickness: 1.0, height: 1.0),
                  itemCount: roles.length);
            }));
  }
}
