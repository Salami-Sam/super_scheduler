import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'group_management.dart';

///A screen where a user can enter a code to join a group
///@author: James Chartraw
class JoinGroupWidget extends StatefulWidget {
  @override
  _JoinGroupWidgetState createState() => _JoinGroupWidgetState();
}

var groupCode;
var db = FirebaseFirestore.instance;
CollectionReference groups = db.collection('groups');
CollectionReference users = db.collection('users');
//var newGroupKey = firebase.database().ref().child('groups').push().key;

/* Future<String> getAllGroups() async {
  var snapshot = groups.get();
  print(snapshot);
  return snapshot.toString();
} */

/* void joinAGroup(groupCode) async {
  //get group code
  //add member to group
}

Future<Map> getGroups() async {
  Map returnMap;
  await groups.where('name').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['name'];
      print("in getGroups()");
      print(returnMap);
    } else {
      print("Error, groups not found");
    }
  });
  return uidToGroups(returnMap);
}

Future<Map> uidToGroups(Map groups) async {
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
 */

Future<void> findGroup(String groupCode) async {
  QuerySnapshot query =
      await groups.where('group_code', isEqualTo: '$groupCode').get();
  print(query);
  DocumentSnapshot document = query.docs.first;
  var docId = document.id;
  if (docId != null) {
    return joinGroup(docId);
  } else {
    print('Error');
  }
}

Future<void> joinGroup(var docId) async {
  var user = FirebaseAuth.instance.currentUser.uid;
  await groups.doc('$docId').update({'Members.$user': 'NA'});
  await users.doc('$user').update({
    'userGroups': FieldValue.arrayUnion([docId])
  });
}

class _JoinGroupWidgetState extends State<JoinGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Join Group'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Code',
                ),
                onChanged: (text) {
                  groupCode = text;
                },
              )),
          ElevatedButton(
              onPressed: () {
                findGroup(groupCode);
              },
              child: Text('Join Group')),
        ])));
  }
}
