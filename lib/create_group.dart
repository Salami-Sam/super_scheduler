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

var newGroupName;
var newGroupDescription;

void addAGroup(newGroupName, newGroupDescription) async {
  FirebaseFirestore.instance
      .collection("groups")
      .doc()
      .set({'name': newGroupName, 'description': newGroupDescription});
}

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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyGroupsWidget()));
                //TODO: submit the form
              },
              child: Text('Create Group')),
        ])));
  }
}
