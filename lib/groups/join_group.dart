import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///A screen where a user can enter a code to join a group
///@author: James Chartraw & Mike Schommer

var groupCode;
var db = FirebaseFirestore.instance;
CollectionReference groups = db.collection('groups');
CollectionReference users = db.collection('users');

//query groups based on their group code
Future<bool> findGroup(String groupCode) async {
  QuerySnapshot query =
      await groups.where('group_code', isEqualTo: '$groupCode').get();
  if (query.size == 1) {
    //a group was found
    DocumentSnapshot document = query.docs.first;
    var docId = document.id;
    if (docId != null) {
      return joinGroup(docId);
    }
  } else {
    return false;
  }
  return true;
}

//adds new user to a group
Future<bool> joinGroup(var docId) async {
  var user = FirebaseAuth.instance.currentUser.uid;
  var displayName = FirebaseAuth.instance.currentUser.displayName;
  print(docId);
  QuerySnapshot userGroupsQuery =
      await users.where('userGroups', arrayContains: '$docId').where('displayName', isEqualTo: '$displayName').get();
  if (userGroupsQuery.size == 1) {
    //if userGroups contains the group ID and the displayName is the same as the user who is currently signed in
    //return false. this prevents users from joining a group twice. 
    return false;
  } else {
    await groups.doc('$docId').update({
      'Members.$user': 'NA'
    }); //adds yourself to new group, assigns NA as role
    await users.doc('$user').update({
      'userGroups': FieldValue.arrayUnion([docId])
    });
    return true;
  }
}

class JoinGroupWidget extends StatefulWidget {
  @override
  _JoinGroupWidgetState createState() => _JoinGroupWidgetState();
}

class _JoinGroupWidgetState extends State<JoinGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Join Group'),
        ),
        body: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
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
                    onPressed: () async {
                      bool goodJoin = await findGroup(groupCode);
                      if (goodJoin) {
                        var snackBar = SnackBar(
                            content: Text(
                                'Join was successful! Welcome!')); 
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      } else {
                        var snackBar = SnackBar(
                            content: Text(
                                'Error! Make sure code is correct and you are not in group already')); 
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('Join Group')),
              ],
            )));
  }
}
