import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'group_management.dart';

///A screen where a users can create their own group.
///They give their group a name and description and then it is created.
///@author: James Chartraw
class CreateGroupWidget extends StatefulWidget {
  @override
  _CreateGroupWidgetState createState() => _CreateGroupWidgetState();
}

var newGroup;

void addAGroup(newGroup) async {
  FirebaseFirestore.instance.collection("groups").doc().set({'name': newGroup});
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {
  TextEditingController groupController = TextEditingController();
  String groupName = '';
  String groupDescription = '';

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
                controller: groupController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Name',
                ),
                onChanged: (groupNametext) {
                  setState(() {
                    groupName = groupNametext;
                  });
                },
              )),
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: groupController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Description',
                ),
                onChanged: (groupDescriptiontext) {
                  setState(() {
                    groupDescription = groupDescriptiontext;
                  });
                },
              )),
          ElevatedButton(
              onPressed: () {
                newGroup = groupName;
                addAGroup(newGroup);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyGroupsWidget()));
                //TODO: submit the form
              },
              child: Text('Create Group')),
        ])));
  }
}
