import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'group_management.dart';

///A screen where a users can create their own group.
///They give their new group a name and description and then it is created
///in the firebase and the user is returned to the home screen
///@author: James Chartraw
class CreateGroupWidget extends StatefulWidget {
  @override
  _CreateGroupWidgetState createState() => _CreateGroupWidgetState();
}

var db = FirebaseFirestore.instance;
var newGroupName;
var newGroupDescription;
var newGroupCode;
var uid = FirebaseAuth.instance.currentUser.uid;

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

void addAGroup(newGroupName, newGroupDescription) async {
  /* if (!newGroupName || !newGroupDescription) {
    return;
  } else */
  newGroupCode = getRandomString(6);
  db.collection("groups").doc().set({
    'name': newGroupName,
    'description': newGroupDescription,
    'group_code': newGroupCode,
    'roles': [],
    'Admins': {'UserID': uid},
    'Managers': {},
    'Members': {}
  });
}

/* void addGrouptoUser() async {

} */

class _CreateGroupWidgetState extends State<CreateGroupWidget> {
  final groupNameController = new TextEditingController();
  final groupDescriptionController = new TextEditingController();
  String groupName = '';
  String groupDescription = '';

  @override
  void dispose() {
    groupDescriptionController.dispose();
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Group'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: groupNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Name',
                ),
                onChanged: (text) {},
              )),
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: groupDescriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Description',
                ),
                onChanged: (text) {},
              )),
          ElevatedButton(
              onPressed: () {
                newGroupName = groupNameController.text;
                newGroupDescription = groupDescriptionController.text;
                addAGroup(newGroupName, newGroupDescription);
                Navigator.of(context).pop(
                    MaterialPageRoute(builder: (context) => MyGroupsWidget()));
              },
              child: Text('Create Group')),
        ])));
  }
}
